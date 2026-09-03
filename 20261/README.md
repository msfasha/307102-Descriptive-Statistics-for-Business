# 307102 — Statistics for Business (R Track)

**University of Petra** | A Quarto/R parallel track to the Excel course.

A complete R version of 307102, teaching the same statistics in the same order as the
Excel materials. Nothing in the original course folders has been changed — students
may use either track, or both.

Built with **Quarto**, which ships bundled with RStudio (v2022.07.1 and later), so
there is nothing extra for students to install.

---

## Structure

```
R-Version/
├── _quarto.yml                   project + website config, shared format options
├── index.qmd                     course home page
│
├── 1-Intro-to-R-Language/
│     Install-Guide.qmd           Posit Cloud or local RStudio
│     setup.R                     run once: packages, data, verification
│     Fast-Intro-to-R.qmd         the eight things needed before any statistics
│
├── 2-Descriptive-Statistics/
│     Descriptive-Statistics.qmd            (+ -SOLUTIONS.qmd)
│
├── 3-Inferential-Statistics/
│     3.1-Probability-Distributions.qmd            (+ SOLUTIONS)
│     3.2-Estimation-and-Confidence-Intervals.qmd  (+ SOLUTIONS)
│     3.3-Hypothesis-Testing.qmd                   (+ SOLUTIONS)
│     3.4-Linear-Regression.qmd                    (+ SOLUTIONS)
│
├── assets/
│     petra-theme.scss            brand colours + heading and callout styling
│     convert-rmd-to-qmd.py       the one-off .Rmd → .qmd converter, kept for reference
│
├── data/                         datasets (populated by setup.R)
├── _freeze/                      cached chunk results — commit this
└── _site/                        rendered website — gitignored, regenerate
```

## Mapping to the Excel course

| R Track | Original |
|---|---|
| 1 — Intro to R Language | *(new)* |
| 2 — Descriptive Statistics | Part 1 |
| 3.1 — Probability Distributions | Part 2.1 |
| 3.2 — Estimation and Confidence Intervals | Part 2.2 |
| 3.3 — Hypothesis Testing | Part 2.3 |
| 3.4 — Linear Regression | Part 2.4 |

Each teaching section has a **student version** with gaps to fill in, and a
**SOLUTIONS version** with worked answers, expected results (all verified against the
real data), marking guidance and teaching notes.

---

## Rendering

Open `307102-R-Track.Rproj` in RStudio, then either:

- **One page:** click **Render** on any open `.qmd`
- **The whole website:** Build pane → **Render Website**, or in the Terminal:

```
quarto render          # build everything into _site/
quarto preview         # live-reloading preview while editing
```

`_site/index.html` is the course home page. The site is self-contained — you can zip
`_site/` and hand it out, or publish it with `quarto publish` to Posit Connect,
Netlify or GitHub Pages.

### Why `_freeze/` is committed

Quarto caches executed chunk results in `_freeze/`. Committing it means the site
rebuilds without re-running R, everyone sees identical numbers, and a rendering
machine needs no R packages at all. To force a page to re-execute, delete its folder
under `_freeze/`.

---

## Why Quarto rather than R Markdown

Four reasons, in order of importance for this course:

1. **Native callouts.** `::: {.callout-warning}` is first-class syntax. The previous
   R Markdown version hand-rolled these as raw `<div>` blocks, which broke pandoc's
   section nesting and left a large blank area at the end of every page.
2. **Stricter execution.** Quarto halts on a chunk error by default; `knitr::knit()`
   records the error into the output and carries on. Converting surfaced two genuine
   bugs that had been silently swallowed.
3. **`code-fold`.** The SOLUTIONS files open with code collapsed, so the interpretation
   reads first and the mechanics are one click away.
4. **Language-agnostic.** The same authoring system covers the Python-based courses
   (Intro to AI, Big Data, GenAI), so there is one toolchain rather than two.

---

## The dataset spine

Almost every example uses **one dataset**: `supermarket_sales.xlsx` — 1,000
transactions from a chain with three branches. Learning statistics and R at once is
already two things; a new business context every week would make it three.

| Column | Meaning | Level |
|---|---|---|
| `Invoice ID` | Unique receipt number | Nominal |
| `Branch`, `City` | Which branch, and where | Nominal |
| `Customer type` | Member or Normal | Nominal |
| `Gender` | Male or Female | Nominal |
| `Product line` | Six categories | Nominal |
| `Unit price` | Price per item | Ratio |
| `Quantity` | Items purchased | Ratio (discrete) |
| `Tax 5%`, `Total` | Tax, and amount paid including tax | Ratio |
| `Date`, `Time` | When it happened | Interval |
| `Payment` | Cash, Credit card, Ewallet | Nominal |
| `cogs`, `gross income` | Cost of goods sold, profit | Ratio |
| `Rating` | Customer satisfaction, 1–10 | Interval |

Also copied into `data/`: **`superstore.xlsx`** (9,994 rows — **use this for assessed
regression work**, since `Total` in the supermarket data is arithmetically determined
by `Quantity` and `Unit price`) and **`fifa18_clean.csv`**.

---

## How R is taught

**Section 1 covers eight concepts and no more** — data frames, `$`, reading a file,
the pipe `|>`, and the five `dplyr` verbs. No loops, no writing functions.

**Every notebook opens with a "New R this week" table** of the functions it
introduces, never more than five or six.

**The scaffolding decays:**

| Section | What the student writes |
|---|---|
| 2 | Fills blanks: `mean(sales$______)` |
| 3.1–3.2 | The function calls, from a commented skeleton |
| 3.3 | The whole chunk, from a described procedure |
| 3.4 | Everything, from a business question |

---

## A note on results

**Most tests in section 3 come back non-significant.** That is deliberate and is the
most valuable feature of this dataset.

Students arrive expecting statistics to produce findings. What it mostly produces is
the disciplined conclusion that an apparent pattern is indistinguishable from noise. A
course where every test is significant teaches students to expect significance — and
they then go and find it whether it is there or not.

Say this in the first session of section 3, or students will conclude they have done
something wrong.

---

## Getting started

1. Read `1-Intro-to-R-Language/Install-Guide.qmd` — 10 minutes locally, or 30 seconds
   on Posit Cloud.
2. Open `307102-R-Track.Rproj` in RStudio. This sets the working directory and is the
   most common fix for "file not found" errors.
3. Run `1-Intro-to-R-Language/setup.R` once. It installs packages, copies the datasets
   into `data/`, and verifies the columns load as expected.
4. Work through section 1, then 2, then 3 in order.

---

## For the instructor

**Committing the data.** The course root `.gitignore` excludes `**/beta/`, where the
original `supermarket_sales.xlsx` lives — so the primary dataset is not in version
control at its original location. `setup.R` copies it to `R-Version/data/`, which *is*
tracked. **Run setup once and commit `R-Version/data/`**, or students who clone will
get a MISSING warning.

**Styling.** All pages share `assets/petra-theme.scss`. Change the look there, not in
individual `.qmd` files. Callout colours are remapped onto Quarto's semantic classes:
note = purple (exercises), warning = amber (gotchas), tip = teal (key ideas), caution
= grey (instructor notes).

**Headings must stay real markdown headings.** Do not wrap them in raw `<div>` blocks
— that is what caused the trailing-whitespace bug in the R Markdown version.

**Two R gotchas baked into the notebooks**, both hit during conversion and both now
taught explicitly rather than worked around silently:

- `TukeyHSD()` fails with `undefined columns selected` on a model whose predictor
  name contains a space. Section 3.3 creates a `product_line` column first and
  explains why.
- Inside `tibble()`, a column assigned early shadows a function argument of the same
  name for later columns. Section 3.2's CLT simulation names its argument `size_n` to
  avoid this.
