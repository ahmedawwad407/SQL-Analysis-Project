# SQL Layoffs Data Analysis

## 📌 Project Overview

This project focuses on **Data Cleaning and Exploratory Data Analysis (EDA)** using SQL.

The dataset contains company layoff records, including company information, industry, funding, company stage, layoff counts, and layoff percentages.

The project demonstrates how SQL can be used to transform raw data into a clean dataset and generate meaningful business insights.

---

## 🎯 Objectives

- Clean and prepare raw layoff data for analysis.
- Identify and remove duplicate records.
- Standardize inconsistent data values.
- Check for missing and invalid values.
- Validate numerical and date fields.
- Perform Exploratory Data Analysis (EDA).
- Identify companies, industries, countries, and company stages most affected by layoffs.
- Analyze layoff trends over time.
- Generate actionable insights from the data.

---

## 🛠️ Technologies Used

- **MariaDB / MySQL**
- SQL
- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- Data Cleaning
- Exploratory Data Analysis (EDA)

---

## 📂 Dataset

The dataset contains the following columns:

| Column | Description |
|---|---|
| `company` | Company name |
| `location` | Company location |
| `industry` | Company industry |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Percentage of workforce laid off |
| `date` | Layoff date |
| `stage` | Company funding/business stage |
| `country` | Company country |
| `funds_raised_millions` | Total funds raised in millions |

---

## 🧹 Data Cleaning Process

The raw dataset was preserved and cleaning was performed using a staging table.

### 1. Staging Table

Created `layoffs_staging` from the raw dataset:

```sql
CREATE TABLE layoffs_staging
LIKE layoffs_raw;
```

The raw data was then copied into the staging table for cleaning.

### 2. Duplicate Detection

Used `ROW_NUMBER()` with a CTE to identify duplicate records.

Three duplicate records were identified and removed.

### 3. Data Standardization

Standardized inconsistent categorical values, including capitalization differences such as:

```text
FinTech → Fintech
```

### 4. Missing Values

Checked all relevant columns for missing or blank values.

**Result:** No missing values were found in the cleaned dataset.

### 5. Numerical Validation

Validated:

- `total_laid_off`
- `percentage_laid_off`
- `funds_raised_millions`

No negative values or invalid layoff percentages were found.

### 6. Final Clean Dataset

The dataset was reduced from **49 raw records to 46 cleaned records** after duplicate removal.

A final table named:

```text
layoffs_cleaned
```

was created for analysis.

---

# 📊 Exploratory Data Analysis

The cleaned dataset was analyzed from multiple perspectives.

## 1. Companies With the Highest Layoffs

**Getir** recorded the highest total number of layoffs:

**4,500 employees**

Other companies with high layoffs included:

- Uber — 3,700
- Groupon — 2,800
- Byju's — 2,500
- WeWork — 2,400

---

## 2. Layoffs by Year

| Year | Employees Laid Off |
|---|---:|
| 2020 | 15,788 |
| 2022 | 15,896 |

The dataset contains records for **2020 and 2022**, with no 2021 records.

2022 recorded slightly more layoffs than 2020.

---

## 3. Layoffs by Country

The **United States** recorded the highest total number of layoffs in the analyzed country results:

**15,688 employees**

---

## 4. Layoffs by Industry

The **Transportation** industry recorded the highest total number of layoffs:

**8,154 employees across 8 records**

---

## 5. Layoffs by Company Stage

**Post-IPO** companies recorded the highest total number of layoffs:

**18,312 employees across 25 records**

---

## 6. Highest Layoff Percentage

**Groupon** recorded the highest individual layoff percentage:

**44%**

---

## 7. Monthly Layoff Trend

The highest monthly number of layoffs occurred in:

**June 2022 — 11,616 employees**

Other notable months included:

- May 2020 — 6,170
- April 2020 — 5,712
- July 2022 — 4,280

---

## 8. Average Layoff Percentage by Industry

The **Travel** industry had the highest average layoff percentage:

**25%**

Followed by:

- Retail — 22.5%
- Cryptocurrency — 18%
- Transportation — 14.38%

---

## 9. Top Companies by Layoff Percentage

| Company | Industry | Layoff % | Employees |
|---|---|---:|---:|
| Groupon | Retail | 44% | 2,800 |
| Bird | Transportation | 30% | 406 |
| TripAdvisor | Travel | 25% | 900 |
| Airbnb | Travel | 25% | 1,900 |
| Snap | Social Media | 20% | 320 |

---

## 10. Average Layoffs per Record by Company Stage

**Late Stage** companies had the highest average number of layoffs per record:

**903 employees per record**

Followed by:

- Private Equity — 736
- Post-IPO — 732
- Series J — 690

---

# 💡 Key Insights

1. **Getir** recorded the highest total layoffs with **4,500 employees**.
2. **2022** had slightly more layoffs than 2020 in this dataset.
3. The **United States** recorded the highest layoffs among the country results.
4. **Transportation** had the highest total layoffs by industry.
5. **Post-IPO** companies accounted for the highest total layoffs by company stage.
6. **Groupon** had the highest individual layoff percentage at **44%**.
7. **June 2022** was the month with the highest recorded layoffs.
8. **Travel** had the highest average layoff percentage at **25%**.
9. **Groupon, Bird, TripAdvisor, Airbnb, and Snap** had the highest individual layoff percentages.
10. **Late Stage** companies had the highest average layoffs per record.

---

## 📁 Project Structure

```text
SQL-Layoffs-Data-Analysis/
│
├── data/
│   ├── layoffs_raw.csv layoffs_data_analysis.sql
│
├── sql/
│   ├── layoffs_data_analysis.sql
│
└── README.md
```

The SQL file contains the complete workflow, including:

- Data Cleaning
- Duplicate Detection
- Data Standardization
- Data Validation
- Clean Dataset Creation
- Exploratory Data Analysis
- Business Insights

---

## 🚀 Skills Demonstrated

This project demonstrates practical experience with:

- SQL Data Cleaning
- Data Quality Validation
- Duplicate Detection
- CTEs
- Window Functions
- `GROUP BY`
- Aggregate Functions
- `SUM()`
- `AVG()`
- `COUNT()`
- `MIN()` / `MAX()`
- Date Functions
- Data Transformation
- Exploratory Data Analysis
- Business Insight Generation

---

## 👨‍💻 Author

**Ahmed W. M. Awwad**

Data Analyst | IT & Software Developer

[LinkedIn](https://linkedin.com/in/ahmedwadieawwad/)
[GitHub](https://github.com/ahmedawwad407)