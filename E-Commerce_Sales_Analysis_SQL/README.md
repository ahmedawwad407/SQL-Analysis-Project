# 🛒 E-Commerce Sales Analysis — SQL

## 📌 Project Overview

This project focuses on cleaning, validating, and analyzing an e-commerce sales dataset using **MySQL**.

The dataset contains customer, product, and order information with intentionally introduced data quality issues such as:

- Duplicate records
- Missing values
- Invalid numerical values
- Inconsistent text formatting
- Invalid dates
- Logical inconsistencies

The goal was to transform the raw data into a clean and reliable dataset and then perform business analysis to identify sales, profitability, customer, product, discount, and market insights.

---

## 🎯 Project Objectives

- Clean and standardize raw e-commerce data
- Identify and handle duplicate records
- Detect and replace invalid values
- Handle missing data using appropriate methods
- Validate relationships between tables
- Calculate key business KPIs
- Analyze revenue and profitability
- Identify top-performing products and customers
- Analyze discount performance
- Compare sales across countries and categories
- Extract actionable business insights

---

## 🗂️ Dataset Structure

The project contains three main tables:

### Customers

| Column | Description |
|---|---|
| Customer_ID | Unique customer identifier |
| Customer_Name | Customer name |
| Gender | Customer gender |
| Age | Customer age |
| City | Customer city |
| Country | Customer country |

### Products

| Column | Description |
|---|---|
| Product_ID | Unique product identifier |
| Product_Name | Product name |
| Category | Product category |
| Subcategory | Product subcategory |
| Unit_Price | Product selling price |
| Cost | Product cost |

### Orders

| Column | Description |
|---|---|
| Order_ID | Unique order identifier |
| Customer_ID | Customer reference |
| Order_Date | Date of order |
| Product_ID | Product reference |
| Quantity | Quantity purchased |
| Discount | Discount applied |

---

# 🧹 Data Cleaning Process

The raw tables were preserved and separate **Staging Tables** were created for data cleaning.

### Staging Tables

```text
Customers_Staging
Products_Staging
Orders_Staging
```

This approach ensures that the original raw data remains unchanged.

---

## 1. Duplicate Records

Duplicate records were identified using `ROW_NUMBER()` and removed from the staging tables.

Examples:

- Duplicate Customer IDs were identified.
- Duplicate Order IDs were identified.
- Product IDs were checked for uniqueness.

The original raw tables were preserved.

---

## 2. Missing Values

Missing values were identified using SQL aggregation and conditional checks.

Examples included:

- Missing order dates
- Missing customer information
- Missing product subcategories
- Missing numerical values

Appropriate replacement strategies were selected based on the type of data.

---

## 3. Invalid Values

Invalid values were identified and corrected.

Examples:

- Negative quantities
- Invalid discounts
- Zero or negative prices
- Invalid customer ages
- Invalid dates

For numerical fields, median-based imputation was used where appropriate.

---

## 4. Data Standardization

Inconsistent values were standardized.

Examples:

```text
M → Male
phones → Phones
Home and Kitchen → Home & Kitchen
```

Whitespace was also removed using `TRIM()`.

---

## 5. Referential Integrity

Relationships between the tables were validated using SQL joins.

The following relationships were verified:

```text
Orders → Customers
Orders → Products
```

All customer and product references in the cleaned Orders table were validated successfully.

---

# 📊 Key Performance Indicators

Revenue was calculated using:

```text
Revenue = Unit_Price × Quantity × (1 - Discount)
```

### Overall Results

| KPI | Result |
|---|---:|
| Total Revenue | **$5,613,144.78** |
| Total Cost | **$3,877,247.53** |
| Total Profit | **$1,735,897.25** |
| Profit Margin | **30.93%** |
| Average Order Value | **$3,772.27** |
| Total Orders | **1,500** |

---

# 📈 Business Analysis

## Revenue by Category

| Category | Revenue |
|---|---:|
| Electronics | $1,421,559.48 |
| Clothing | $1,102,047.07 |
| Home & Kitchen | $1,013,916.51 |
| Beauty | $952,146.35 |
| Sports | $714,548.08 |
| Books | $408,927.28 |

**Insight:** Electronics generated the highest revenue, while Books generated the lowest.

---

## Profit by Category

| Category | Profit |
|---|---:|
| Electronics | $468,435.33 |
| Beauty | $320,046.17 |
| Clothing | $309,313.20 |
| Home & Kitchen | $287,195.98 |
| Sports | $211,076.34 |
| Books | $139,830.22 |

**Insight:** Electronics generated the highest total profit.

---

## Profit Margin by Category

| Category | Profit Margin |
|---|---:|
| Books | 34.19% |
| Beauty | 33.61% |
| Electronics | 32.95% |
| Sports | 29.54% |
| Home & Kitchen | 28.33% |
| Clothing | 28.07% |

**Insight:** Books had the highest profit margin despite having the lowest overall revenue.

This demonstrates the difference between **sales volume and profitability efficiency**.

---

## Revenue by Year

| Year | Revenue |
|---|---:|
| 2024 | $2,870,351.52 |
| 2025 | $2,742,793.26 |

Revenue decreased by approximately **4.44% in 2025** compared with 2024.

---

## Top 10 Customers by Revenue

The highest-revenue customer was:

**Customer 152 — $55,561.68**

The Top 10 customers showed relatively balanced revenue contributions, with the remaining customers generating between approximately **$43.79K and $54.04K**.

---

## Top 10 Products by Revenue

| Product | Category | Revenue |
|---|---|---:|
| Product 88 | Electronics | $158,735.63 |
| Product 20 | Clothing | $148,246.90 |
| Product 32 | Electronics | $147,267.61 |
| Product 6 | Electronics | $132,567.88 |
| Product 75 | Sports | $130,465.74 |

**Insight:** Product 88 generated the highest revenue at **$158.74K**.

Electronics appeared most frequently among the Top 10 revenue-generating products.

---

## Top 10 Products by Profit

The highest-profit product was:

**Product 32 — $101,198.05**

An important business observation was identified:

> The product with the highest revenue was not the product with the highest profit.

Product 88 ranked #1 in revenue, while Product 32 ranked #1 in profit.

---

## Orders by Category

| Category | Orders |
|---|---:|
| Electronics | 342 |
| Home & Kitchen | 282 |
| Clothing | 273 |
| Beauty | 235 |
| Sports | 184 |
| Books | 172 |

**Insight:** Electronics had the highest number of orders with **342**, while Books had the lowest with **172**.

---

## Average Order Value by Category

| Category | AOV |
|---|---:|
| Electronics | $4,156.61 |
| Beauty | $4,051.69 |
| Clothing | $4,036.80 |
| Sports | $3,883.41 |
| Home & Kitchen | $3,595.45 |
| Books | $2,377.48 |

**Insight:** Electronics had the highest Average Order Value, while Books had the lowest.

---

# 💰 Discount Analysis

## Revenue by Discount

| Discount | Revenue |
|---|---:|
| 0% | $2,005,587.04 |
| 2% | $553,036.97 |
| 5% | $974,504.38 |
| 10% | $1,147,466.30 |
| 15% | $554,118.60 |
| 20% | $231,784.54 |
| 25% | $146,646.96 |

The **10% discount level** generated the highest revenue among discounted orders.

---

## Profit by Discount

| Discount | Profit |
|---|---:|
| 0% | $718,245.54 |
| 2% | $205,531.65 |
| 5% | $287,942.80 |
| 10% | $338,104.40 |
| 15% | $120,606.10 |
| 20% | $46,173.46 |
| 25% | $19,293.30 |

**Insight:** Higher discount levels were associated with substantially lower total profit in this dataset.

> Note: This analysis shows association within the dataset and does not establish that discounts directly caused the decrease in profit.

---

# 🌍 Revenue by Country

| Country | Revenue |
|---|---:|
| Egypt | $1,692,660.44 |
| Jordan | $1,525,222.28 |
| Saudi Arabia | $1,273,938.85 |
| Palestine | $1,055,823.81 |

**Insight:** Egypt generated the highest revenue at approximately **$1.69M**, while Palestine generated the lowest.

---

# 📅 Monthly Revenue Analysis

Monthly revenue varied considerably between 2024 and 2025.

### 2024

- Highest month: **October — $292,296.21**
- Lowest month: **January — $160,993.20**

### 2025

- Highest month: **November — $293,688.37**
- Lowest month: **May — $162,481.51**

The monthly revenue pattern changed noticeably between the two years.

For example:

- July increased from **$183K in 2024** to **$286K in 2025**
- May decreased from **$282K in 2024** to **$162K in 2025**

---

# 🔍 Key Business Insights

### 1. Electronics was the strongest category

Electronics ranked first in:

- Revenue
- Profit
- Number of orders
- Presence among top-performing products

This makes Electronics the strongest overall category in the dataset.

### 2. High revenue does not always mean high profitability

Product 88 generated the highest revenue, while Product 32 generated the highest profit.

This highlights the importance of analyzing **profit alongside revenue**.

### 3. Books had strong profitability efficiency

Books generated the lowest total revenue but achieved the highest profit margin at **34.19%**.

### 4. Revenue declined in 2025

Total revenue decreased from **$2.87M in 2024** to **$2.74M in 2025**, representing approximately a **4.44% decline**.

### 5. Discounts should be monitored carefully

The 10% discount level produced the strongest results among discounted orders, while higher discount levels were associated with significantly lower total profit.

### 6. Egypt was the strongest market

Egypt generated approximately **$1.69M**, making it the highest-revenue country in the dataset.

### 7. Monthly performance was inconsistent

The strongest month changed between years, indicating that monthly performance was not consistent across the two-year period.

---

# 🛠️ Technologies Used

- **MySQL**
- SQL
- MySQL Workbench
- Git & GitHub

### SQL Techniques

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `JOIN`
- `CASE`
- `ROUND`
- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `ROW_NUMBER()`
- Window Functions
- CTEs
- Data Cleaning
- Data Validation
- Aggregation
- NULL Handling
- Median Imputation

---

# 📁 Project Structure

```text
E-Commerce_Sales_Analysis_SQL/
│
├── data/
│   ├── Customers.csv
│   ├── Products.csv
│   └── Orders.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_data_validation.sql
│   └── 03_data_analysis.sql
│
├── README.md
```

---

# 🚀 Project Workflow

```text
Raw Data
   ↓
Data Inspection
   ↓
Create Staging Tables
   ↓
Duplicate Detection
   ↓
Missing Value Handling
   ↓
Invalid Value Correction
   ↓
Data Standardization
   ↓
Referential Integrity Validation
   ↓
KPI Calculation
   ↓
Business Analysis
   ↓
Insights
```

---

# 📌 Conclusion

This project demonstrates an end-to-end SQL data analysis workflow, starting from messy raw e-commerce data and transforming it into a clean and analysis-ready dataset.

The analysis identified key patterns in:

- Sales performance
- Product profitability
- Customer behavior
- Discount effectiveness
- Geographic performance
- Category performance
- Monthly revenue trends

The project also demonstrates practical SQL skills including data cleaning, staging, validation, joins, window functions, aggregation, and business-focused analysis.

---

## 👨‍💻 Author

**Ahmed W. M. Awwad**

Data Analyst | IT & Software Developer

[LinkedIn](https://linkedin.com/in/ahmedwadieawwad/)
[GitHub](https://github.com/ahmedawwad407)