# ADsP R Lab Curriculum

## Purpose

This file defines what each hands-on lab should teach.

It is a practical study decomposition for ADsP preparation, not an official K-DATA syllabus or a prediction of future exam questions.

The curriculum focuses on the ADsP data-analysis area commonly studied as:

- R basics and data marts
- statistical analysis
- structured data mining

Labs are intended to be studied in numeric order, but every script must remain independently runnable.

---

## Lab 00 — RStudio Setup

**File:** `labs/00_setup.R`

**Outcome**
- Confirm that R is available from RStudio.
- Distinguish the Console from an R script.
- Run simple expressions and assignments.

**Concepts**
- Console vs script
- assignment
- objects
- session information

**R surface**
- `<-`
- `R.version.string`
- `sessionInfo()`
- basic arithmetic

**Dataset**
- Small inline values only

**Must interpret**
- Where an expression is entered versus where reusable code is saved
- What assignment does
- That `sessionInfo()` describes the running R environment

**Out of scope**
- package management
- IDE customization
- project tooling

---

## Lab 01 — R Basics and Data Structures

**File:** `labs/01_r_basics.R`

**Outcome**
- Distinguish common R data structures.
- Read basic structure and summary output.
- Predict simple indexing results.

**Concepts**
- vector
- matrix
- factor
- list
- data.frame
- indexing

**R surface**
- `c()`
- `matrix()`
- `factor()`
- `list()`
- `data.frame()`
- `class()`
- `str()`
- `summary()`

**Dataset**
- Small inline data created in the script

**Must interpret**
- Homogeneous vector/matrix versus mixed-type data.frame/list
- How factor levels represent categories
- Row/column indexing results
- What `class()`, `str()`, and `summary()` reveal

**Key contrast**
- matrix vs data.frame
- factor vs character/vector

**Out of scope**
- file I/O
- statistical modeling
- tidyverse

---

## Lab 02 — Data Handling

**File:** `labs/02_data_handling.R`

**Outcome**
- Select rows or values with logical conditions.
- Combine small data frames by a key.
- Recognize common apply-family behavior and legacy data-manipulation vocabulary.

**Concepts**
- logical indexing
- filtering
- joining/merging
- split/apply/combine idea
- reshape vocabulary

**R surface**
- logical indexing with `[]`
- `subset()`
- `merge()`
- `apply()`
- `lapply()`
- `sapply()`

**Dataset**
- Small inline data frames

**Must interpret**
- Which observations satisfy a condition
- Inner-style matching versus retaining unmatched rows with `merge()`
- The difference between list and simplified apply-family results
- The purpose, at recognition level, of reshape, plyr, sqldf, and data.table

**Key contrast**
- `lapply()` vs `sapply()`
- data manipulation vocabulary vs required package mastery

**Out of scope**
- installing or teaching reshape/plyr/sqldf/data.table APIs in depth
- tidyverse workflow
- large-data engineering

---

## Lab 03 — Missing Values, Outliers, and Binning

**File:** `labs/03_missing_outliers.R`

**Outcome**
- Detect and handle missing values in simple summaries.
- Recognize potential outliers with quartiles/IQR and a boxplot.
- Convert numeric values into simple intervals.

**Concepts**
- NA
- missing-value handling
- quartiles
- IQR
- outlier rule
- discretization/binning

**R surface**
- `is.na()`
- `sum()`
- `mean(..., na.rm = TRUE)`
- `quantile()`
- `IQR()`
- `boxplot()`
- `cut()`

**Dataset**
- `airquality` plus a small inline vector when useful

**Must interpret**
- Why a summary can become `NA`
- What `na.rm = TRUE` changes
- How the 1.5 × IQR rule relates to boxplot outliers
- How numeric values map into bins

**Key contrast**
- missing value vs outlier

**Out of scope**
- advanced imputation
- anomaly-detection algorithms

---

## Lab 04 — Descriptive Statistics, Correlation, and Probability

**File:** `labs/04_descriptive_probability.R`

**Outcome**
- Interpret common descriptive statistics and simple plots.
- Read the direction and strength of a correlation.
- Use a basic probability-distribution function and interpret the result.

**Concepts**
- mean
- median
- variance
- standard deviation
- quantile
- correlation
- normal/binomial probability

**R surface**
- `mean()`
- `median()`
- `var()`
- `sd()`
- `quantile()`
- `cor()`
- `hist()`
- `boxplot()`
- simple use of `pnorm()` and/or `dbinom()`

**Dataset**
- `mtcars`

**Must interpret**
- Center versus spread
- Positive, negative, and near-zero correlation
- Correlation does not establish causation
- What a probability returned by `pnorm()` or `dbinom()` represents

**Key contrast**
- variance vs standard deviation
- correlation vs causation

**Out of scope**
- distribution-theory proofs
- advanced probability derivations

---

## Lab 05 — Hypothesis Tests

**File:** `labs/05_hypothesis_tests.R`

**Outcome**
- Identify null and alternative hypotheses.
- Interpret a p-value against a significance level.
- Recognize common parametric, categorical, and nonparametric tests.

**Concepts**
- null hypothesis
- alternative hypothesis
- significance level
- p-value
- t-test
- chi-square test
- nonparametric test

**R surface**
- `t.test()`
- `chisq.test()`
- `wilcox.test()`

**Dataset**
- `mtcars` and small contingency data created in the script

**Must interpret**
- Test statistic and p-value
- Whether the null hypothesis is rejected at a stated alpha
- The correct wording when the null hypothesis is not rejected
- Which data/problem shape fits each demonstrated test

**Key contrast**
- reject H0 vs fail to reject H0
- parametric vs nonparametric

**Out of scope**
- derivation of test statistics
- exhaustive test selection

---

## Lab 06 — Linear Regression

**File:** `labs/06_regression.R`

**Outcome**
- Read simple and multiple linear-regression output.
- Interpret coefficient direction and significance.
- Interpret R-squared and adjusted R-squared.

**Concepts**
- dependent variable
- independent variable
- simple regression
- multiple regression
- coefficient
- residual
- model fit

**R surface**
- `lm()`
- `summary()`
- `residuals()`
- a simple diagnostic plot

**Dataset**
- `mtcars`

**Must interpret**
- `Estimate`
- coefficient sign
- `Pr(>|t|)`
- `Multiple R-squared`
- `Adjusted R-squared`
- what residuals represent

**Key contrast**
- simple vs multiple regression
- R-squared vs adjusted R-squared

**Out of scope**
- VIF deep dive
- regularization
- polynomial regression
- cross-validation

---

## Lab 07 — Time Series

**File:** `labs/07_time_series.R`

**Outcome**
- Recognize trend and seasonality in a time-series plot.
- Read basic decomposition output.
- Connect ACF/PACF patterns with AR and MA concepts.

**Concepts**
- time series
- trend
- seasonality
- irregular component
- stationarity at recognition level
- AR
- MA
- ARMA
- ARIMA

**R surface**
- `plot()`
- `decompose()`
- `acf()`
- `pacf()`

**Dataset**
- `AirPassengers`

**Must interpret**
- Observed, trend, seasonal, and random components
- What ACF and PACF display
- The usual exam-level heuristic: PACF cutoff for AR and ACF cutoff for MA
- Why differencing appears in ARIMA

**Key contrast**
- AR vs MA
- ARMA vs ARIMA

**Out of scope**
- fitting and comparing many forecasting models
- forecast-package workflows

---

## Lab 08 — MDS and PCA

**File:** `labs/08_mds_pca.R`

**Outcome**
- Explain the different goals of MDS and PCA.
- Run a basic example of each.
- Read the main output and plots at an exam-preparation level.

**Concepts**
- distance/dissimilarity
- low-dimensional representation
- principal components
- scaling
- explained variance
- loadings

**R surface**
- `dist()`
- `cmdscale()`
- `scale()`
- `prcomp()`
- `summary()`
- simple plots

**Dataset**
- `USArrests`

**Must interpret**
- MDS as preserving pairwise distance/dissimilarity as well as possible
- PCA as constructing variance-oriented component axes
- Why scaling can matter
- Explained variance by principal components
- Loading direction/magnitude at a basic level

**Key contrast**
- MDS vs PCA

**Out of scope**
- matrix derivations
- kernel methods
- t-SNE/UMAP

---

## Lab 09 — Logistic Regression and Model Evaluation

**File:** `labs/09_model_evaluation_logistic.R`

**Outcome**
- Understand the purpose of train/test separation.
- Read basic logistic-regression probabilities.
- Calculate and distinguish common classification metrics.

**Concepts**
- train/test split
- binary outcome
- logistic regression
- predicted probability
- confusion matrix
- accuracy
- precision
- recall/sensitivity
- specificity
- F1
- ROC/AUC at recognition level

**R surface**
- `sample()`
- `glm(..., family = binomial)`
- `predict(..., type = "response")`
- `table()`
- manual metric calculations

**Dataset**
- `mtcars` with `am` as a binary outcome

**Must interpret**
- Probability output from logistic regression
- TP, FP, FN, TN
- The denominator used by precision, recall, and specificity
- Why accuracy alone can be insufficient
- ROC/AUC as model-evaluation concepts

**Key contrast**
- linear vs logistic regression
- precision vs recall
- training data vs test data

**Out of scope**
- tuning frameworks
- cross-validation packages
- automated ML pipelines

---

## Lab 10 — Decision Trees and Ensemble Methods

**File:** `labs/10_tree_ensemble.R`

**Outcome**
- Read a small decision-tree split.
- Explain the basic idea of bagging, boosting, and random forest.
- Distinguish ensemble concepts without requiring a package survey.

**Concepts**
- decision tree
- recursive splitting
- terminal node
- bagging
- boosting
- random forest

**R surface**
- a small tree with `rpart::rpart()` when the recommended package is available
- simple tree inspection/plotting
- conceptual comparison code or comments for ensembles

**Dataset**
- `iris`

**Must interpret**
- What a split condition means
- How observations move toward terminal nodes
- Bagging as parallel resampling/aggregation
- Boosting as sequential focus on errors
- Random forest as bagging plus random feature selection

**Key contrast**
- bagging vs boosting
- single tree vs random forest

**Out of scope**
- boosting-library implementation
- random-forest tuning
- exhaustive tree-pruning theory

---

## Lab 11 — Neural Network Basics

**File:** `labs/11_neural_network.R`

**Outcome**
- Understand basic neural-network vocabulary.
- Calculate and compare common activation functions.
- Interpret their output ranges.

**Concepts**
- node
- input
- weight
- bias
- activation function
- sigmoid
- tanh
- ReLU

**R surface**
- small inline functions for sigmoid and ReLU
- `tanh()`
- vectorized calculations/plots when useful

**Dataset**
- Small inline numeric inputs

**Must interpret**
- Weighted input plus bias at a conceptual level
- Sigmoid range
- tanh range
- ReLU behavior for negative and positive input

**Key contrast**
- sigmoid vs tanh vs ReLU

**Out of scope**
- TensorFlow/PyTorch
- backpropagation derivation
- deep-network training

---

## Lab 12 — Clustering

**File:** `labs/12_clustering.R`

**Outcome**
- Distinguish hierarchical and partition-based clustering.
- Interpret a dendrogram and k-means assignment.
- Recognize DBSCAN and SOM as different clustering approaches.

**Concepts**
- unsupervised learning
- distance
- hierarchical clustering
- dendrogram
- k-means
- centroid
- DBSCAN
- SOM

**R surface**
- `dist()`
- `hclust()`
- `plot()`
- `kmeans()`
- `table()`

**Dataset**
- `iris` numeric columns; species may be used only after clustering for comparison

**Must interpret**
- Why clustering is unsupervised
- How a dendrogram represents merges
- What K controls in k-means
- Cluster assignments and centers
- DBSCAN as density-based and SOM as competitive-learning concepts

**Key contrast**
- classification vs clustering
- hierarchical vs k-means
- k-means vs DBSCAN

**Out of scope**
- package-heavy clustering surveys
- advanced cluster-validation indices

---

## Lab 13 — Association Rules

**File:** `labs/13_association.R`

**Outcome**
- Calculate support, confidence, and lift from transaction counts.
- Interpret each measure.
- Understand directionality of confidence.

**Concepts**
- itemset
- association rule
- support
- confidence
- lift

**R surface**
- arithmetic with small transaction counts
- simple named variables/functions when useful

**Dataset**
- Small inline transaction counts

**Must interpret**
- support as joint frequency/proportion
- confidence of A -> B
- confidence of B -> A
- lift relative to 1
- why confidence generally changes with rule direction

**Key contrast**
- support vs confidence vs lift
- confidence(A -> B) vs confidence(B -> A)

**Out of scope**
- installing association-rule mining packages
- mining large transaction datasets

---

## Scope guardrail

A topic being useful in real-world data science is not, by itself, a reason to add it to a lab.

Before expanding a lab, ask:

1. Does it directly improve understanding of the ADsP concept defined for this lab?
2. Can it be demonstrated clearly without new infrastructure?
3. Will the learner inspect or interpret something useful after running it?

If not, leave it out.
