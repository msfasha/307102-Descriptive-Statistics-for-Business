## Superstore Sales Dataset – Integrated Analysis Scenario

### Scenario Overview

**Business Context:**
A national retail chain, *Global Superstore*, wants to understand its sales performance across product categories, regions, and customer segments.
The management team seeks insights to:

* Identify high- and low-performing categories.
* Understand profitability drivers.
* Evaluate whether discounts are improving sales or eroding profits.
* Develop data-driven recommendations to increase revenue.

---

## 1. Define the Problem

**Main Business Questions:**

1. What are the general sales and profit patterns across categories and regions?
2. Are discounts effective in increasing sales volume or do they reduce profit margins?
3. Which customer segment contributes the most to profitability?
4. Are there seasonal trends in sales performance?

---

## 2. Collect and Prepare the Data

**Dataset:** [Superstore Sales](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

**Variables of Interest:**

* **Numerical:** Sales, Profit, Quantity, Discount, Shipping Cost
* **Categorical:** Region, Category, Sub-Category, Segment, Ship Mode
* **Date:** Order Date, Ship Date

**Preparation Tasks:**

* Handle missing or duplicate entries
* Create derived variables such as *Profit Margin = Profit / Sales*
* Convert *Order Date* into *Month* and *Year* for time-based analysis

---

## 3. Descriptive Statistics and Visualization

### 3.1 Measures of Central Tendency and Dispersion

**Objective:** Summarize the overall performance.

* Compute **mean**, **median**, **mode** for `Sales` and `Profit`.
* Calculate **range**, **variance**, **standard deviation**, and **coefficient of variation** to assess consistency.
* Compare sales dispersion across product categories.

**Example Insights:**

> Average sales per order = $230, median = $110 → distribution is right-skewed due to a few large orders.

---

### 3.2 Frequency and Distribution Tables

* Create a **frequency table** for the number of orders per region.
* Build a **cross-tab** (contingency table) between *Region* and *Category* to show how sales are distributed.

---

### 3.3 Data Visualization

**Qualitative (Categorical) Data:**

* **Bar chart:** Sales by region or by category.
* **Pie chart:** Proportion of total sales by customer segment.
* **Pareto chart:** Identify top categories contributing to 80% of sales.

**Quantitative (Numeric) Data:**

* **Histogram:** Distribution of order profit. Identify outliers and skewness.
* **Boxplot:** Compare profit distribution across regions.
* **Scatterplot:** Explore relationship between discount and profit.

---

## 4. Measures of Relationship

### 4.1 Covariance and Correlation

**Objective:** Measure relationships between numeric variables.

* Compute **correlation** between `Discount` and `Profit`.

  * Expect a negative correlation if higher discounts reduce profits.
* Correlate `Sales` and `Profit` to see whether higher sales consistently yield higher profits.

**Example Insight:**

> Correlation(Discount, Profit) = -0.42 → strong negative relationship.

---

### 4.2 Cross-tab and Chi-square Tests

**Objective:** Examine association between categorical variables.

* Perform a **Chi-square test** between *Region* and *Category* to test if sales distribution differs significantly across regions.

---

## 5. Distribution Shape and Outliers

### 5.1 Skewness and Kurtosis

* Assess the **skewness** of `Profit` and `Sales` distributions to identify asymmetry.
* Interpret results using histograms.

**Example:**

> Profit distribution is positively skewed, meaning most orders yield small profits with a few extreme outliers.

### 5.2 Outlier Detection

* Use **IQR** method or **Z-scores** to detect outliers in `Profit`.
* Investigate whether outliers correspond to bulk orders or data entry errors.

**Visualization:** Boxplot of profit per category.

---

## 6. Inferential and Comparative Analysis

### 6.1 Hypothesis Testing

**Example 1 – Mean Comparison (t-test):**

> H₀: The mean profit for “Technology” category equals that of “Furniture.”
>
> Conduct a two-sample t-test to determine if there’s a significant difference.

**Example 2 – ANOVA:**

> Test whether average sales differ significantly among regions.

**Example 3 – Proportion Test:**

> Compare proportion of orders above $500 between corporate and consumer segments.

---

### 6.2 Regression Analysis

**Objective:** Predict profit and understand key drivers.

* **Simple Linear Regression:** Profit = f(Discount)
* **Multiple Regression:** Profit = f(Sales, Discount, Category, Region)
* Interpret coefficients to explain the business meaning of each driver.

**Example Result:**

> Every 10% increase in discount reduces profit by an average of $15 per order, holding other factors constant.

---

## 7. Reporting and Communication

**Final Deliverable:**
A short report or dashboard summarizing:

* Key descriptive statistics (tables and charts)
* Significant relationships and hypothesis results
* Regression findings with business interpretation
* Actionable recommendations

**Example Insights to Present:**

* “Technology” has the highest average sales but moderate profit margins.
* The “South” region shows high sales variability (high coefficient of variation).
* High discounts significantly erode profit — especially in furniture category.
* Seasonal spikes in December and back-to-school months suggest inventory planning opportunities.

---

## 8. Skills and Tools Alignment

| Topic                  | Example from Scenario        | Tool(s)                            |
| ---------------------- | ---------------------------- | ---------------------------------- |
| Descriptive Statistics | Mean, Median, Range of Sales | Excel, Python (pandas)             |
| Frequency Tables       | Orders by Region, Segment    | Excel PivotTables                  |
| Data Visualization     | Histogram, Boxplot, Pareto   | Excel Charts, Matplotlib           |
| Correlation Analysis   | Discount vs Profit           | Excel CORREL, Python `.corr()`     |
| Hypothesis Testing     | ANOVA on regional sales      | Excel Data Analysis ToolPak, SciPy |
| Regression             | Predicting Profit            | Excel Regression, statsmodels      |
| Outlier Detection      | IQR, Boxplot of Profit       | Excel, Python seaborn/matplotlib   |

---

## 9. Notes

* All datasets are free to download and can be used in **Excel, R, Python, or Power BI**.
* For smaller workshops or short courses, start with **Superstore Sales** or **HR Attrition**.
* For advanced or MBA-level sessions, integrate **S&P 500** or **Airbnb** for richer analysis.
* Encourage students to explore relationships between variables using **both visualization and statistical inference**.

---

