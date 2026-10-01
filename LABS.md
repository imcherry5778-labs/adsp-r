# ADsP R Lab Curriculum

This file defines what each hands-on lab should teach. It is a practical study decomposition for ADsP preparation, not an official K-DATA syllabus or a prediction of future exam questions.

The curriculum focuses on R basics/data marts, statistical analysis, and structured data mining. Labs are intended to be studied in numeric order, but every script must remain independently runnable.

## Lab 00 — RStudio Setup

- **File:** `labs/00_setup.R`
- **Outcome:** Confirm R works in RStudio; distinguish Console from script; run simple expressions and assignments.
- **Concepts:** Console vs script, assignment, objects, session information.
- **R surface:** `<-`, `R.version.string`, `sessionInfo()`, basic arithmetic.
- **Dataset:** Small inline values.
- **Must interpret:** Where reusable code lives; what assignment does; what `sessionInfo()` describes.
- **Out of scope:** Package management, IDE customization, project tooling.

## Lab 01 — R Basics and Data Structures

- **File:** `labs/01_r_basics.R`
- **Outcome:** Distinguish common R data structures; read structure/summary output; predict simple indexing.
- **Concepts:** vector, matrix, factor, list, data.frame, indexing.
- **R surface:** `c()`, `matrix()`, `factor()`, `list()`, `data.frame()`, `class()`, `str()`, `summary()`.
- **Dataset:** Small inline data.
- **Must interpret:** homogeneous vs mixed-type structures; factor levels; row/column indexing; what `class()`, `str()`, and `summary()` reveal.
- **Key contrast:** matrix vs data.frame; factor vs character/vector.
- **Out of scope:** File I/O, statistical modeling, tidyverse.

## Lab 02 — Data Handling

- **File:** `labs/02_data_handling.R`
- **Outcome:** Select observations by condition; combine small data frames; recognize apply-family behavior and ADsP data-manipulation vocabulary.
- **Concepts:** logical indexing, filtering, joining/merging, split-apply-combine, data-manipulation vocabulary.
- **R surface:** `[]`, `subset()`, `merge()`, `apply()`, `lapply()`, `sapply()`.
- **Dataset:** Small inline data frames.
- **Must interpret:** condition results; matched/unmatched rows in `merge()`; list vs simplified apply results; purpose of reshape, plyr, sqldf, and data.table at recognition level.
- **Key contrast:** `lapply()` vs `sapply()`; vocabulary recognition vs package mastery.
- **Out of scope:** Installing/teaching reshape/plyr/sqldf/data.table APIs in depth, tidyverse workflow, large-data engineering.

## Lab 03 — Missing Values, Outliers, and Binning

- **File:** `labs/03_missing_outliers.R`
- **Outcome:** Detect/handle missing values; recognize potential outliers; bin numeric values.
- **Concepts:** NA, missing-value handling, quartiles, IQR, 1.5×IQR rule, discretization.
- **R surface:** `is.na()`, `sum()`, `mean(..., na.rm = TRUE)`, `quantile()`, `IQR()`, `boxplot()`, `cut()`.
- **Dataset:** `airquality` plus a small inline vector when useful.
- **Must interpret:** why summaries can become `NA`; effect of `na.rm`; boxplot/IQR outlier rule; mapping values into bins.
- **Key contrast:** missing value vs outlier.
- **Out of scope:** Advanced imputation, anomaly-detection algorithms.

## Lab 04 — Descriptive Statistics, Correlation, and Probability

- **File:** `labs/04_descriptive_probability.R`
- **Outcome:** Interpret common descriptive statistics/plots, correlation, and a basic probability result.
- **Concepts:** mean, median, variance, standard deviation, quantile, correlation, normal/binomial probability.
- **R surface:** `mean()`, `median()`, `var()`, `sd()`, `quantile()`, `cor()`, `hist()`, `boxplot()`, simple `pnorm()` and/or `dbinom()`.
- **Dataset:** `mtcars`.
- **Must interpret:** center vs spread; correlation direction/strength; correlation ≠ causation; what returned probabilities mean.
- **Key contrast:** variance vs standard deviation; correlation vs causation.
- **Out of scope:** Distribution proofs, advanced probability derivations.

## Lab 05 — Hypothesis Tests

- **File:** `labs/05_hypothesis_tests.R`
- **Outcome:** Identify H0/H1; interpret p-value against alpha; recognize common parametric, categorical, and nonparametric tests.
- **Concepts:** null/alternative hypothesis, significance level, p-value, t-test, chi-square test, nonparametric test.
- **R surface:** `t.test()`, `chisq.test()`, `wilcox.test()`.
- **Dataset:** `mtcars` plus small contingency data.
- **Must interpret:** test statistic/p-value; reject vs fail to reject H0; which demonstrated test fits which data/problem shape.
- **Key contrast:** reject H0 vs fail to reject H0; parametric vs nonparametric.
- **Out of scope:** Deriving test statistics, exhaustive test selection.

## Lab 06 — Linear Regression

- **File:** `labs/06_regression.R`
- **Outcome:** Read simple/multiple linear-regression output; interpret coefficient direction/significance and model fit.
- **Concepts:** dependent/independent variable, simple/multiple regression, coefficient, residual, model fit.
- **R surface:** `lm()`, `summary()`, `residuals()`, one simple diagnostic plot.
- **Dataset:** `mtcars`.
- **Must interpret:** `Estimate`, coefficient sign, `Pr(>|t|)`, `Multiple R-squared`, `Adjusted R-squared`, residual meaning.
- **Key contrast:** simple vs multiple regression; R-squared vs adjusted R-squared.
- **Out of scope:** VIF deep dive, regularization, polynomial regression, cross-validation.

## Lab 07 — Time Series

- **File:** `labs/07_time_series.R`
- **Outcome:** Recognize trend/seasonality; read decomposition; connect ACF/PACF patterns with AR/MA concepts.
- **Concepts:** time series, trend, seasonality, irregular component, stationarity at recognition level, AR, MA, ARMA, ARIMA.
- **R surface:** `plot()`, `decompose()`, `acf()`, `pacf()`, `arima.sim()`.
- **Dataset:** `AirPassengers` for decomposition plus small simulated stationary AR/MA series for ACF/PACF comparison.
- **Must interpret:** observed/trend/seasonal/random components; what ACF/PACF display; the textbook cutoff heuristic for stationary pure AR/MA processes; why differencing appears in ARIMA.
- **Key contrast:** AR vs MA; ARMA vs ARIMA.
- **Out of scope:** Comparing many forecast models, forecast-package workflows.

## Lab 08 — MDS and PCA

- **File:** `labs/08_mds_pca.R`
- **Outcome:** Distinguish MDS from PCA; run a basic example of each; read core output/plots.
- **Concepts:** distance/dissimilarity, low-dimensional representation, principal components, scaling, explained variance, loadings.
- **R surface:** `dist()`, `cmdscale()`, `scale()`, `prcomp()`, `summary()`, simple plots.
- **Dataset:** `USArrests`.
- **Must interpret:** MDS preserving pairwise distance/dissimilarity; PCA constructing variance-oriented axes; effect of scaling; explained variance; basic loading direction/magnitude.
- **Key contrast:** MDS vs PCA.
- **Out of scope:** Matrix derivations, kernel methods, t-SNE/UMAP.

## Lab 09 — Logistic Regression and Model Evaluation

- **File:** `labs/09_model_evaluation_logistic.R`
- **Outcome:** Understand train/test separation; read logistic probabilities; calculate/distinguish common classification metrics.
- **Concepts:** train/test split, binary outcome, logistic regression, predicted probability, confusion matrix, accuracy, precision, recall/sensitivity, specificity, F1, ROC/AUC at recognition level.
- **R surface:** `sample()`, `glm(..., family = binomial)`, `predict(..., type = "response")`, `table()`, manual metric calculations.
- **Dataset:** `mtcars` with `am` as binary outcome.
- **Must interpret:** predicted probability; TP/FP/FN/TN; metric denominators; why accuracy alone can mislead; ROC/AUC concept.
- **Key contrast:** linear vs logistic regression; precision vs recall; training vs test data.
- **Out of scope:** Tuning frameworks, cross-validation packages, automated ML pipelines.

## Lab 10 — Decision Trees and Ensemble Methods

- **File:** `labs/10_tree_ensemble.R`
- **Outcome:** Read a small decision-tree split; explain bagging, boosting, and random forest at exam-preparation level.
- **Concepts:** decision tree, recursive splitting, terminal node, bagging, boosting, random forest.
- **R surface:** small tree with `rpart::rpart()` when available; simple tree inspection/plotting; ensembles mainly through comparison rather than package execution.
- **Dataset:** `iris`.
- **Must interpret:** split conditions; terminal-node routing; bagging as resampling/aggregation; boosting as sequential error focus; random forest as bagging plus random feature selection.
- **Key contrast:** bagging vs boosting; single tree vs random forest.
- **Out of scope:** Boosting-library implementation, random-forest tuning, exhaustive pruning theory.

## Lab 11 — Neural Network Basics

- **File:** `labs/11_neural_network.R`
- **Outcome:** Understand basic neural-network vocabulary; calculate/compare common activation functions.
- **Concepts:** node, input, weight, bias, activation function, sigmoid, tanh, ReLU.
- **R surface:** small inline sigmoid/ReLU functions, `tanh()`, vectorized calculations/plots when useful.
- **Dataset:** Small inline numeric inputs.
- **Must interpret:** weighted input plus bias concept; sigmoid/tanh ranges; ReLU behavior for negative/positive input.
- **Key contrast:** sigmoid vs tanh vs ReLU.
- **Out of scope:** TensorFlow/PyTorch, backpropagation derivation, deep-network training.

## Lab 12 — Clustering

- **File:** `labs/12_clustering.R`
- **Outcome:** Distinguish hierarchical and partition-based clustering; interpret dendrogram/k-means output; recognize DBSCAN/SOM.
- **Concepts:** unsupervised learning, distance, hierarchical clustering, dendrogram, k-means, centroid, DBSCAN, SOM.
- **R surface:** `dist()`, `hclust()`, `plot()`, `kmeans()`, `table()`.
- **Dataset:** Numeric columns of `iris`; species may be used only after clustering for comparison.
- **Must interpret:** why clustering is unsupervised; dendrogram merges; role of K; assignments/centers; DBSCAN as density-based; SOM as competitive learning.
- **Key contrast:** classification vs clustering; hierarchical vs k-means; k-means vs DBSCAN.
- **Out of scope:** Package-heavy clustering surveys, advanced cluster-validation indices.

## Lab 13 — Association Rules

- **File:** `labs/13_association.R`
- **Outcome:** Calculate and interpret support, confidence, and lift; understand confidence directionality.
- **Concepts:** itemset, association rule, support, confidence, lift.
- **R surface:** arithmetic with small transaction counts; simple named variables/functions when useful.
- **Dataset:** Small inline transaction counts.
- **Must interpret:** support as joint frequency/proportion; confidence A→B and B→A; lift relative to 1; why confidence generally changes with rule direction.
- **Key contrast:** support vs confidence vs lift; confidence(A→B) vs confidence(B→A).
- **Out of scope:** Installing association-rule packages, mining large transaction datasets.

## Scope guardrail

A topic being useful in real-world data science is not, by itself, a reason to add it to a lab. Expand a lab only when the addition directly improves the defined ADsP concept, can be demonstrated clearly without new infrastructure, and gives the learner something useful to inspect or interpret.
