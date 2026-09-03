#!/usr/bin/env python3
"""
Convert the course .Rmd notebooks to Quarto .qmd.

Kept deliberately mechanical: R code chunks are copied byte-for-byte. Only the
YAML header and the hand-rolled HTML callouts are rewritten.

Callout mapping (Quarto semantics, course colours supplied by petra-theme.scss):

    div.callout.yourturn    ->  ::: {.callout-note}       exercises, self-checks
    div.callout.watchout    ->  ::: {.callout-warning}    gotchas, Excel differences
    div.callout.keyidea     ->  ::: {.callout-tip}        conceptual points
    div.callout.instructor  ->  ::: {.callout-caution}    instructor-only notes
    <details><summary>X</summary>  ->  nested collapsible callout

Nesting uses Quarto's colon-fence rule: an outer fence needs more colons than
the inner one, so outer callouts that contain a collapsible answer are opened
with four colons.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

CLASS_MAP = {
    "yourturn":   "callout-note",
    "watchout":   "callout-warning",
    "keyidea":    "callout-tip",
    "instructor": "callout-caution",
}

FILES = [
    "1-Intro-to-R-Language/Fast-Intro-to-R",
    "2-Descriptive-Statistics/Descriptive-Statistics",
    "2-Descriptive-Statistics/Descriptive-Statistics-SOLUTIONS",
    "3-Inferential-Statistics/3.1-Probability-Distributions",
    "3-Inferential-Statistics/3.1-Probability-Distributions-SOLUTIONS",
    "3-Inferential-Statistics/3.2-Estimation-and-Confidence-Intervals",
    "3-Inferential-Statistics/3.2-Estimation-and-Confidence-Intervals-SOLUTIONS",
    "3-Inferential-Statistics/3.3-Hypothesis-Testing",
    "3-Inferential-Statistics/3.3-Hypothesis-Testing-SOLUTIONS",
    "3-Inferential-Statistics/3.4-Linear-Regression",
    "3-Inferential-Statistics/3.4-Linear-Regression-SOLUTIONS",
]


def protect_chunks(text):
    """Replace fenced code blocks with placeholders so nothing rewrites them."""
    chunks = []

    def stash(m):
        chunks.append(m.group(0))
        return f"\x00CHUNK{len(chunks) - 1}\x00"

    text = re.sub(r"^```.*?^```\s*$", stash, text, flags=re.S | re.M)
    return text, chunks


def restore_chunks(text, chunks):
    for i, c in enumerate(chunks):
        text = text.replace(f"\x00CHUNK{i}\x00", c)
    return text


def build_yaml(title, subtitle, is_solutions):
    """Quarto YAML. Format options live in _quarto.yml; only per-file keys here."""
    lines = [
        "---",
        f'title: "{title}"',
        f'subtitle: "{subtitle}"',
    ]
    if is_solutions:
        # Instructor copies open with code collapsed so the interpretation reads
        # first and the mechanics are one click away.
        lines += [
            "code-fold: true",
            'code-summary: "Show the code"',
        ]
    lines += ["---"]
    return "\n".join(lines)


def convert_details(text):
    """
    <details><summary>X</summary> ... </details>
        -> ::: {.callout-note collapse="true" title="X"} ... :::

    Uses three colons; the caller widens any enclosing fence.
    """
    pattern = re.compile(
        r"<details>\s*\n<summary>(.*?)</summary>\s*\n(.*?)\n</details>",
        flags=re.S,
    )

    def repl(m):
        title = m.group(1).strip()
        body = m.group(2).strip("\n")
        return (
            f'::: {{.callout-note collapse="true" title="{title}"}}\n'
            f"{body}\n"
            f":::"
        )

    return pattern.sub(repl, text)


def convert_callouts(text):
    """
    <div class="callout X">
    <span class="label">Title</span>
    body
    </div>
        -> ::: {.callout-Y title="Title"}  body  :::

    Widened to four colons when the body contains a nested fence.
    """
    pattern = re.compile(
        r'<div class="callout (\w+)">\s*\n'
        r'(?:<span class="label">(.*?)</span>\s*\n)?'
        r"(.*?)"
        r"\n</div>",
        flags=re.S,
    )

    def repl(m):
        css_class = m.group(1)
        title = (m.group(2) or "").strip()
        body = m.group(3).strip("\n")

        quarto_class = CLASS_MAP.get(css_class)
        if quarto_class is None:
            print(f"  WARNING: unmapped callout class '{css_class}'", file=sys.stderr)
            quarto_class = "callout-note"

        fence = "::::" if ":::" in body else ":::"

        attrs = f".{quarto_class}"
        if title:
            attrs += f' title="{title}"'

        return f"{fence} {{{attrs}}}\n{body}\n{fence}"

    return pattern.sub(repl, text)


def convert(stem):
    src = ROOT / f"{stem}.Rmd"
    dst = ROOT / f"{stem}.qmd"

    if not src.exists():
        print(f"  SKIP (missing): {src}")
        return False

    text = src.read_text(encoding="utf-8")

    # Pull the title and subtitle out of the old YAML before discarding it.
    old_yaml = re.match(r"^---\n(.*?)\n---\n", text, flags=re.S)
    title = re.search(r'^title:\s*"(.*)"', old_yaml.group(1), flags=re.M).group(1)
    sub_m = re.search(r'^subtitle:\s*"(.*)"', old_yaml.group(1), flags=re.M)
    subtitle = sub_m.group(1) if sub_m else ""

    body = text[old_yaml.end():]

    # Protect code, transform prose, restore code.
    body, chunks = protect_chunks(body)
    body = convert_details(body)
    body = convert_callouts(body)
    body = restore_chunks(body, chunks)

    # The old setup chunk only set knitr defaults that _quarto.yml now owns.
    body = re.sub(
        r"^```\{r setup, include=FALSE\}\n.*?\n```\n\n?",
        "",
        body,
        flags=re.S | re.M,
    )

    out = build_yaml(title, subtitle, stem.endswith("SOLUTIONS")) + "\n" + body

    # Leftover raw HTML would mean something was missed.
    leftover = re.findall(r"</?(?:div|details|summary|span)\b", out)
    if leftover:
        print(f"  WARNING: {len(leftover)} raw HTML tags remain in {stem}",
              file=sys.stderr)

    dst.write_text(out, encoding="utf-8")

    print(f"  {stem}.qmd  "
          f"(callouts: {out.count(':::')//2}, raw HTML: {len(leftover)})")
    return True


if __name__ == "__main__":
    print("Converting .Rmd -> .qmd\n")
    n = sum(convert(s) for s in FILES)
    print(f"\n{n} files converted.")
