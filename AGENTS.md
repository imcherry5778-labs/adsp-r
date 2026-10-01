# ADsP R Lab — Agent Instructions

## Purpose

This repository is a small set of hands-on RStudio labs for preparing for the ADsP exam.

The goal is not to teach production R development. The goal is to connect:

ADsP concept -> small R example -> observed output/plot -> exam-oriented interpretation

Prefer learning value and exam relevance over software-engineering ceremony.

## Source of truth

- Use `LABS.md` for the curriculum and the scope of each lab.
- For a lab task, implement only the requested lab.
- Do not expand a lab beyond its contract just because a related topic is useful.
- Do not claim that an exercise is an actual past exam question unless a supplied source proves that.

## One task, one lab

A normal task should create or revise exactly one file:

`labs/NN_slug.R`

Do not create another lab, refactor unrelated labs, or add project infrastructure unless the user explicitly asks.

## Lab format

Each lab should be a self-contained R script that can be studied directly in RStudio.

Use this learning flow when it fits the topic:

1. Goal — 1 to 3 things the learner should be able to do.
2. Concept — short comments explaining only what is needed.
3. Worked example — a small, complete example.
4. Predict — ask the learner to predict a value, sign, pattern, or conclusion before running code.
5. Run and interpret — execute code and point out what to inspect in the output or plot.
6. Change one thing — modify one input or option and compare the result.
7. Exam check — 3 to 5 short questions, with answers at the end of the same file.

Keep a lab roughly 10 to 30 minutes long. Prefer a few clear experiments over broad coverage.

## R rules

Prefer Base R and packages that ship with a standard R installation when they are sufficient.

Prefer built-in datasets such as:

- `mtcars`
- `iris`
- `airquality`
- `PlantGrowth`
- `AirPassengers`
- `USArrests`

Do not put these in lab scripts:

- `install.packages()`
- `setwd()`
- machine-specific absolute paths
- internet downloads
- code that depends on objects left in the Global Environment

If randomness is used, call `set.seed()`.

Do not add tidyverse or another package merely to make code look more modern. If an ADsP concept can be demonstrated manually or with Base R, prefer that.

Some syllabus terms such as reshape/plyr/sqldf/data.table, ensemble methods, SOM, or DBSCAN may be taught as exam vocabulary or conceptual comparisons without installing packages when execution adds little learning value.

## Validation

The requested lab must parse and run from top to bottom in a clean session.

After editing it, run:

`Rscript --vanilla labs/NN_slug.R`

Fix errors caused by the lab and rerun it.

A lab should not contain intentionally broken TODO code. Questions and exercises should be comments around executable examples so the full file remains runnable.

Do not create a separate `check.R`, test framework, CI workflow, solution file, lockfile, or environment manager unless a concrete need appears and the user asks for it.

## Content priorities

For statistical/modeling labs, emphasize reading outputs rather than implementing algorithms from scratch.

Examples:

- hypothesis tests: p-value and the correct conclusion
- regression: coefficient sign, p-value, R-squared, adjusted R-squared
- time series: trend/seasonality and ACF/PACF patterns
- PCA/MDS: what is being preserved or summarized
- model evaluation: confusion-matrix metrics and their denominators
- clustering: supervised vs. unsupervised distinctions and method characteristics
- association rules: support, confidence, and lift

Include common exam traps when they materially improve understanding, but do not turn every lab into a long theory note.

## Keep the repository simple

Do not introduce infrastructure in anticipation of future needs.

Add a new dependency, helper script, documentation layer, or automation only when an existing lab actually needs it and the benefit is larger than the maintenance cost.

When the user asks for a lab, finish and validate that lab, report what changed, and stop.
