# House Sales — Correlation & Linear Regression Analysis (R)



## Overview

A full regression analysis pipeline applied to a real estate dataset of 50 properties. The project covers normality testing, correlation analysis, simple linear regression with complete residual diagnostics, and multiple linear regression — following a rigorous assumption-checking workflow throughout.

This is a BSc-level statistics lab project completed as part of a Statistics and Insurance Science degree.

---

## Problem Statement

A real estate consultant wants to understand what drives property selling prices. Data was collected on 50 recently sold properties, recording:

| Variable | Description |
|---|---|
| `price` | Selling price (thousands of euros) |
| `age` | Years since construction |
| `distance` | Distance from city center (meters) |
| `squaremeters` | Property size (m²) |

---

## Tools & Libraries

| Library | Purpose |
|---|---|
| Base R | Data entry, linear modelling (`lm`) |
| `nortest` | Anderson-Darling and Lilliefors normality tests |
| `dplyr` | Data manipulation |
| `Hmisc` | Correlation matrix with p-values |
| `corrplot` | Correlation visualizations |
| `psych` | Pairs panel plots |
| `ggplot2` | Residual diagnostic plots |
| `car` | Durbin-Watson test for autocorrelation |
| `lmtest` | Breusch-Pagan test for heteroscedasticity |
| `MASS` | Studentized residuals |

---

## Analysis

### Step 1 — Normality Testing

All four variables were tested for normality before any modelling:

- **Kolmogorov-Smirnov Test** — applied to each variable
- **Anderson-Darling Test** — applied to each variable

Both methods were used to ensure robustness of the normality assessment.

### Step 2 — Correlation Analysis

Pairwise correlations were computed and visualized across all variables:

- Pearson correlation matrix with p-values using `rcorr()` (Hmisc)
- Scatter plot matrix using base R `plot()` and `pairs()`
- Correlation circle and coefficient plots using `corrplot`
- Enhanced pairs panel with `psych::pairs.panels()`

### Step 3 — Simple Linear Regression

A simple linear regression was fitted relating **price to age**:

```r
fit <- lm(price ~ age, data = data)
# Result: price = 410.359 - 19.971 * age
```

Full residual diagnostics were performed to validate model assumptions:

**Normality of residuals** — tested using KS, Lilliefors, Shapiro-Wilk, and Anderson-Darling tests on standardized residuals.

**Homoscedasticity (constant variance)** — examined via scatter plots of studentized residuals against age and predicted values.

**Independence of residuals** — tested using the **Durbin-Watson test** for autocorrelation (both `car` and `lmtest` implementations).

### Step 4 — Multiple Linear Regression

Extended the model to include all three predictors:

```r
fit1 <- lm(price ~ age + distance + squaremeters, data = data)
```

- ANOVA table computed for the full model
- Residual diagnostic plots generated (`par(mfrow=c(2,2))`)
- **Durbin-Watson test** for autocorrelation
- **Breusch-Pagan test** for heteroscedasticity

---

## Key Concepts Demonstrated

- Normality assumption testing (KS, Anderson-Darling, Shapiro-Wilk, Lilliefors)
- Pearson correlation matrix with significance testing
- Simple and multiple linear regression with `lm()`
- Full residual diagnostics (normality, homoscedasticity, independence)
- Durbin-Watson test for autocorrelation
- Breusch-Pagan test for heteroscedasticity
- Standardized and studentized residual analysis
- Correlation visualization with `corrplot` and `psych`

---

## How to Run

1. Open `house_sales_analysis.R` in RStudio
2. Install required packages if not already installed:
```r
install.packages(c("nortest", "dplyr", "Hmisc", "corrplot", 
                   "psych", "ggplot2", "car", "lmtest", "MASS"))
```
3. Run the script section by section (Normality → Correlation → Simple LR → Multiple LR)

---



**Oresti Janko**
BSc Statistics and Insurance Science — University of Piraeus
Focus: Linear regression, residual diagnostics, statistical modelling in R
