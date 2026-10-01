# ADsP R Lab Curriculum

This file defines the scope of the hands-on labs.

The labs support the ADsP subject area commonly summarized as:

- R basics and data marts
- statistical analysis
- structured data mining

They are practice aids for understanding and interpreting exam concepts, not a claim about the exact wording of future exam questions.

## How to use this file

When generating a lab, use only the matching row as the main content contract together with `AGENTS.md`.

A lab may briefly recall an earlier concept when it helps comparison, but it should not absorb the scope of later labs.

| Lab | File | Main outcome | Must include | Keep out / keep light |
|---|---|---|---|---|
| 00 | `labs/00_setup.R` | Confirm that R/RStudio works and understand script vs Console | arithmetic, assignment, `R.version.string`, `sessionInfo()`, running selected lines vs a script | package management, IDE customization |
| 01 | `labs/01_r_basics.R` | Read and distinguish common R data structures | vector, matrix, factor, list, data.frame, basic indexing, `class()`, `str()`, `summary()` | file I/O, statistics |
| 02 | `labs/02_data_handling.R` | Select, combine, and summarize small datasets | logical indexing, `subset()`, `merge()`, `apply()`/`lapply()`/`sapply()` at recognition level, reshape/plyr/sqldf/data.table as exam vocabulary | tidyverse workflow, large-data engineering |
| 03 | `labs/03_missing_outliers.R` | Recognize and handle missing values, outliers, and simple bins | `is.na()`, `na.rm`, `boxplot()`, quartiles/IQR idea, `cut()` | advanced imputation, anomaly-detection algorithms |
| 04 | `labs/04_descriptive_probability.R` | Interpret descriptive statistics, correlation, and basic probability-distribution functions | mean/median/variance/sd/quantile, `cor()`, histogram/boxplot, simple use of `pnorm()` or `dbinom()` | distribution theory proofs |
| 05 | `labs/05_hypothesis_tests.R` | Choose and interpret common tests | null/alternative hypothesis, significance level, p-value, `t.test()`, chi-square test, one nonparametric example such as `wilcox.test()` | derivation of test statistics |
| 06 | `labs/06_regression.R` | Read simple and multiple linear-regression output | `lm()`, `summary()`, Estimate, coefficient sign, p-value, R-squared, adjusted R-squared, one residual diagnostic view | VIF deep dive, regularization, cross-validation |
| 07 | `labs/07_time_series.R` | Connect a time-series plot with trend/seasonality and ACF/PACF concepts | `AirPassengers`, `decompose()`, `acf()`, `pacf()`, conceptual AR/MA/ARMA/ARIMA distinctions | fitting many competing forecast models |
| 08 | `labs/08_mds_pca.R` | Distinguish MDS from PCA and read their basic outputs | distance idea, `cmdscale()`, `prcomp()`, scaling, explained variance/loadings at interpretation level, simple plots | matrix derivations, advanced dimensionality reduction |
| 09 | `labs/09_model_evaluation_logistic.R` | Understand data splitting, logistic output, and classification metrics | train/test idea, `glm(..., family=binomial)`, probabilities, confusion matrix, accuracy, precision, recall/sensitivity, specificity, F1; ROC/AUC concept | tuning frameworks, cross-validation packages |
| 10 | `labs/10_tree_ensemble.R` | Understand decision-tree output and distinguish major ensemble ideas | tree split interpretation; bagging vs boosting vs random forest conceptual comparison | implementing boosting/RF packages unless explicitly requested |
| 11 | `labs/11_neural_network.R` | Understand basic neural-network vocabulary and activation functions | node/weight/bias concept, sigmoid, tanh, ReLU calculations and ranges | TensorFlow/PyTorch, backpropagation derivation, deep learning |
| 12 | `labs/12_clustering.R` | Compare major clustering approaches and interpret simple results | `dist()`, `hclust()`, dendrogram, `kmeans()`, K choice concept, DBSCAN/SOM as conceptual contrasts | package-heavy clustering surveys |
| 13 | `labs/13_association.R` | Calculate and interpret association-rule measures | transaction counts, support, confidence in both directions, lift, meaning of lift around 1 | mining large transaction datasets with packages |

## General sequencing

The intended order is 00 through 13.

The order is designed so that later labs can briefly reuse earlier ideas:

- Lab 05 reuses descriptive statistics and probability language.
- Lab 06 reuses p-value interpretation.
- Lab 08 contrasts two dimension-reduction/mapping ideas in one session.
- Lab 09 reuses probability and introduces the evaluation vocabulary needed for later modeling topics.
- Labs 10–13 focus more on interpretation and comparison than package-specific syntax.

## Scope guardrail

A topic being useful in real-world data science is not, by itself, a reason to add it to a lab.

When deciding whether to expand a lab, use this order:

1. Does it directly improve understanding of the ADsP concept named in the row?
2. Can it be demonstrated in a few lines without new infrastructure?
3. Will the learner inspect or interpret something useful after running it?

If the answer is no, leave it out.
