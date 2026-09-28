# Customer_Marketing_Analysis_SQL — Raw Dataset

This dataset is intentionally **dirty** for SQL Server data-cleaning and analytics practice.

## Tables
- Customers_Raw.csv
- Products_Raw.csv
- Orders_Raw.csv
- Marketing_Campaigns_Raw.csv
- Campaign_Responses_Raw.csv

## Intended workflow
Raw Data → Staging → Cleaning → Validation → Analysis → Business Insights

## Intentional data-quality issues
- Duplicate Customer IDs / customer rows
- Duplicate Orders
- Duplicate Campaign Responses
- Missing Gender, Age, City
- Invalid Age values
- Missing Product information
- Missing Customer/Product references
- Negative and zero Quantity
- Invalid Discount values
- Missing and invalid dates
- Missing budgets
- Negative campaign budget
- Inconsistent Category values and casing
- Inconsistent Channel values
- Invalid Conversion values
- NULL values

## Suggested SQL Server skills
JOINs, CTEs, CASE, Subqueries, Aggregations, Window Functions,
RANK(), ROW_NUMBER(), LAG(), SUM() OVER(), Date Functions,
Data Validation, Customer Segmentation, Marketing Analytics.
