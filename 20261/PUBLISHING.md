# Publishing the course website

The site is built from `20261/` and served from the repository's `gh-pages`
branch. Students get a URL; they never clone anything.

**Live URL** (once set up):
`https://msfasha.github.io/307102-Descriptive-Statistics-for-Business/`

---

## One-time setup

You only do this once.

**1. Push the workflow.** Commit `.github/workflows/publish.yml` (at the
repository root, not inside `20261/`) and push to `main`.

**2. Create the `gh-pages` branch.** The very first publish has to come from
your machine, because GitHub Pages needs the branch to exist before it can serve
it. From inside `20261/`:

```
quarto publish gh-pages
```

It will ask you to confirm, render the site, create the branch and push it.

**3. Turn on GitHub Pages.** In the repository on GitHub:
**Settings → Pages → Build and deployment → Source: Deploy from a branch**,
then choose branch **`gh-pages`**, folder **`/ (root)`**, and Save.

Wait a minute or two, then load the URL above.

---

## After that: normal working

```
# edit a .qmd, then locally:
quarto render          # from inside 20261/ - check it looks right

git add -A
git commit -m "Update section 3.3"
git push
```

The push triggers the workflow, which rebuilds and updates the live site in
about a minute. Watch it under the repository's **Actions** tab.

To publish by hand instead, skip the workflow and run `quarto publish gh-pages`
from `20261/`.

---

## Why the runner does not need R

`20261/_freeze/` is committed. It holds the executed output of every R chunk —
printed results and generated plots. Quarto reuses it instead of running R, so
the GitHub runner only installs Quarto.

Two consequences worth understanding:

**The published numbers are exactly the ones you saw locally.** Nothing is
recomputed on a different machine with different package versions.

**If you change R code, render locally before pushing.** The render updates
`_freeze/`, and you must commit that change along with the `.qmd`. If you push a
code change without the matching `_freeze/` update, the site will rebuild using
the *old* results and appear not to have changed.

To force a page to re-execute, delete its folder under `_freeze/` and render
again.

---

## What gets published

| Path | Published? |
|---|---|
| `_site/` | Yes — this *is* the site, rebuilt on the runner |
| `.qmd` sources | No — but they stay on `main`, publicly readable |
| `_freeze/` | No — used during the build only |
| `data/` | Only files the pages actually link to |

**The SOLUTIONS pages are published too.** They are ordinary pages in the site
and are listed in the sidebar. If you do not want students reading the marking
guidance, either remove those entries from the `sidebar` section of
`_quarto.yml` — note that this hides them from navigation but the URL still
works — or move the files out of the project before publishing. There is no
password protection on GitHub Pages.

---

## Troubleshooting

**The Actions run fails with a permissions error.**
Repository **Settings → Actions → General → Workflow permissions** →
select *Read and write permissions*.

**The site builds but shows a 404.**
GitHub Pages is probably still pointed at `main`. Check
Settings → Pages → Source is `gh-pages` / `/ (root)`.

**A page is stale after pushing.**
You changed R code without committing the updated `_freeze/`. Render locally,
commit both, push again.

**The slides do not open from a page.**
The link is relative (`*-slides.html`), so it only works from the rendered site,
not from a `.qmd` preview in RStudio.
