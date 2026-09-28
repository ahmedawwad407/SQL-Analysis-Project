# Customer & Marketing Analytics SQL

## Project Overview
SQL portfolio project analyzing customers, products, orders, marketing campaigns, and campaign responses.

### Business Questions
- Who are the highest-value customers?
- Which products and categories generate the most revenue?
- Which marketing campaigns receive the most responses?
- What is the customer response rate?
- What is the Average Order Value?
- What is the Customer Lifetime Value (CLV) proxy?

## Project Structure
```text
Customer_Marketing_Analysis_SQL/
├── data/
│   └── raw/
│       ├── Customers_Raw.csv
│       ├── Products_Raw.csv
│       ├── Orders_Raw.csv
│       ├── Marketing_Campaigns_Raw.csv
│       └── Campaign_Responses_Raw.csv
├── sql/
│   ├── 01_data_profiling.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_data_analysis.sql
│   └── 04_business_insights.sql
├── README.md
```

## Workflow
**Raw Data → Data Profiling → Data Cleaning → Data Analysis → Business Insights**

The raw data is intentionally preserved. Cleaning creates separate cleaned tables rather than modifying the source files.

## SQL Files
1. `01_data_profiling.sql` — data quality checks, NULLs, duplicates, ranges, and samples.
2. `02_data_cleaning.sql` — creates cleaned tables and validates the results.
3. `03_data_analysis.sql` — customer, sales, product, category, monthly and campaign analysis.
4. `04_business_insights.sql` — portfolio-ready KPIs and business insight queries.

## Tools
- SQL
- CSV
- GitHub

## Author
**Ahmed Awwad**
