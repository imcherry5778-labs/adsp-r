# ADsP R Lab — Agent Instructions

## Purpose

This repository contains small RStudio labs for preparing for the ADsP exam.

The goal is not production R development or a full R course. Each lab should help the learner connect:

ADsP concept -> predict -> run R code -> inspect output/plot -> interpret -> exam check

Prefer exam relevance, conceptual clarity, and runnable examples over software-engineering ceremony.

## Learner

Assume the learner:

- is preparing for the ADsP exam
- is a beginner in R
- already has R and RStudio installed
- wants conceptual understanding and output interpretation, not R mastery

## Sources of truth

- `AGENTS.md` defines how lab work is performed.
- `LABS.md` defines the curriculum and the scope of each lab.
- For a lab task, follow only the requested lab section in `LABS.md` plus these shared rules.
- Do not edit `LABS.md` or redesign the curriculum unless the user explicitly asks.
- Do not expand a lab beyond its contract just because a related topic is useful.

## Task boundary

For a normal lab-generation task:

- create or revise exactly one file: `labs/NN_slug.R`
- do not start another lab
- do not refactor unrelated labs
- do not add dependencies or project infrastructure unless the requested lab clearly requires them
- finish and validate the requested lab, report the result, and stop

## Lab file contract

Each lab is one self-contained R script that can be studied directly in RStudio.

Use RStudio code sections so the script is easy to navigate:

```r
# 1. 목표 --------------------------------------------------------
# 2. 핵심 개념 ---------------------------------------------------
# 3. 먼저 예상하기 -----------------------------------------------
# 4. 직접 실행 ----------------------------------------------------
# 5. 결과 해석 ----------------------------------------------------
# 6. 하나 바꿔보기 ------------------------------------------------
# 7. 시험 체크 ----------------------------------------------------
# 정답 및 해설 ----------------------------------------------------
```

Use that flow when it fits the topic. Do not force a section when it adds no learning value.

A typical lab should:

- state 1 to 3 concrete learning outcomes
- explain only the theory needed for the experiment
- include a small worked example
- ask the learner to predict a value, sign, pattern, or conclusion before running code
- make the learner inspect and interpret the important output or plot
- change one input or option and compare the result
- end with 3 to 5 short exam-check questions and answers

Keep each lab roughly 10 to 30 minutes long. Prefer a few clear experiments over broad coverage.

## Language

Learner-facing explanations, prompts, interpretations, and quizzes must be written in Korean.

Keep R function names, object names, statistical notation, and standard technical terms idiomatic.

## R conventions

- Prefer Base R and recommended R packages when they are sufficient.
- Use the dataset and R surface defined for the requested lab in `LABS.md`.
- Keep each script independently runnable.
- Use `set.seed()` when randomness is involved.
- Do not use `install.packages()`.
- Do not use `setwd()`.
- Do not depend on objects created by another lab or left in the Global Environment.
- Do not require internet access.
- Do not add tidyverse or another package merely to make the code look more modern.
- Avoid implementing algorithms from scratch when a small R example can demonstrate the exam concept more clearly.
- A concept may be taught as a comparison or calculation without installing a package when package execution adds little learning value.

## Non-interactive and side effects

A lab must run unattended from top to bottom.

Avoid interactive-only operations such as:

- `View()`
- `readline()`
- menus or prompts
- click-based graphics

Lab scripts must not create, modify, or download files as a side effect.

## Validation

After editing a lab, validate it in a clean non-interactive session.

For labs without plotting:

```sh
Rscript --vanilla labs/NN_slug.R
```

For labs that create plots, suppress file output during validation:

```sh
Rscript --vanilla -e "pdf(NULL); source('labs/NN_slug.R')"
```

Fix errors caused by the lab and rerun validation.

If `Rscript` is unavailable, report that validation could not be executed. Never claim that validation succeeded without running it.

Do not create a separate `check.R`, solution file, test framework, CI workflow, lockfile, or environment manager unless a concrete need appears and the user explicitly asks for it.

## Evidence and exam claims

Do not claim that an exercise is an actual past exam question unless a supplied source proves that.

Do not claim that a topic is frequent, recently tested, or asked in a specific way unless that claim is supported by a source provided for the task.

Otherwise describe the item neutrally as an ADsP exam-preparation point.

## Keep the repository simple

Do not introduce infrastructure in anticipation of future needs.

Add a dependency, helper script, documentation layer, or automation only when an existing task actually needs it and the benefit is larger than the maintenance cost.
