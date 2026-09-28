-- SQL Project #3 - Marketing & Customer Analytics
-- 01_data_profiling.sql
-- MySQL Workbench
-- Raw tables expected:

CREATE DATABASE IF NOT EXISTS marketing_analytics;
USE marketing_analytics;

-- 1. Row counts
SELECT 'Customers_Raw' AS table_name, COUNT(*) AS row_count FROM Customers_Raw
UNION ALL SELECT 'Products_Raw', COUNT(*) FROM Products_Raw
UNION ALL SELECT 'Orders_Raw', COUNT(*) FROM Orders_Raw
UNION ALL SELECT 'Marketing_Campaigns_Raw', COUNT(*) FROM Marketing_Campaigns_Raw
UNION ALL SELECT 'Campaign_Responses_Raw', COUNT(*) FROM Campaign_Responses_Raw;

-- 2. Column definitions
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME IN ('Customers_Raw','Products_Raw','Orders_Raw',
                   'Marketing_Campaigns_Raw','Campaign_Responses_Raw')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 3. Customers
SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT Customer_ID) distinct_customer_ids,
    SUM(Customer_ID IS NULL) null_customer_id,
    SUM(Customer_Name IS NULL OR TRIM(Customer_Name)='') null_customer_name,
    SUM(Gender IS NULL OR TRIM(Gender)='') null_gender,
    SUM(Age IS NULL) null_age,
    SUM(City IS NULL OR TRIM(City)='') null_city,
    SUM(Country IS NULL OR TRIM(Country)='') null_country,
    MIN(Age) min_age, MAX(Age) max_age
FROM Customers_Raw;

SELECT Customer_ID, COUNT(*) duplicate_count
FROM Customers_Raw
GROUP BY Customer_ID HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, Customer_ID;

SELECT DISTINCT Gender FROM Customers_Raw ORDER BY Gender;
SELECT DISTINCT Country FROM Customers_Raw ORDER BY Country;
SELECT DISTINCT City FROM Customers_Raw ORDER BY City;

-- 4. Products
SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT Product_ID) distinct_product_ids,
    SUM(Product_ID IS NULL) null_product_id,
    SUM(Product_Name IS NULL OR TRIM(Product_Name)='') null_product_name,
    SUM(Category IS NULL OR TRIM(Category)='') null_category,
    SUM(Subcategory IS NULL OR TRIM(Subcategory)='') null_subcategory,
    SUM(Unit_Price IS NULL) null_unit_price,
    SUM(Cost IS NULL) null_cost,
    MIN(Unit_Price) min_unit_price, MAX(Unit_Price) max_unit_price,
    MIN(Cost) min_cost, MAX(Cost) max_cost
FROM Products_Raw;

SELECT Product_ID, COUNT(*) duplicate_count
FROM Products_Raw
GROUP BY Product_ID HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, Product_ID;

-- 5. Orders
SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT Order_ID) distinct_order_ids,
    SUM(Order_ID IS NULL) null_order_id,
    SUM(Customer_ID IS NULL) null_customer_id,
    SUM(Order_Date IS NULL OR TRIM(Order_Date)='') null_order_date,
    SUM(Product_ID IS NULL) null_product_id,
    SUM(Quantity IS NULL) null_quantity,
    SUM(Discount IS NULL) null_discount,
    MIN(Order_Date) min_order_date, MAX(Order_Date) max_order_date,
    MIN(Quantity) min_quantity, MAX(Quantity) max_quantity,
    MIN(Discount) min_discount, MAX(Discount) max_discount
FROM Orders_Raw;

SELECT Order_ID, COUNT(*) duplicate_count
FROM Orders_Raw
GROUP BY Order_ID HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, Order_ID;

SELECT
    SUM(Quantity <= 0) non_positive_quantity,
    SUM(Discount < 0 OR Discount > 1) invalid_discount
FROM Orders_Raw;

-- 6. Campaigns
SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT Campaign_ID) distinct_campaign_ids,
    SUM(Campaign_ID IS NULL) null_campaign_id,
    SUM(Campaign_Name IS NULL OR TRIM(Campaign_Name)='') null_campaign_name,
    SUM(Campaign_Type IS NULL OR TRIM(Campaign_Type)='') null_campaign_type,
    SUM(Start_Date IS NULL OR TRIM(Start_Date)='') null_start_date,
    SUM(End_Date IS NULL OR TRIM(End_Date)='') null_end_date,
    SUM(Budget IS NULL) null_budget,
    MIN(Budget) min_budget, MAX(Budget) max_budget
FROM Marketing_Campaigns_Raw;

SELECT Campaign_ID, COUNT(*) duplicate_count
FROM Marketing_Campaigns_Raw
GROUP BY Campaign_ID HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, Campaign_ID;

SELECT DISTINCT Campaign_Type
FROM Marketing_Campaigns_Raw ORDER BY Campaign_Type;

-- 7. Responses
SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT Response_ID) distinct_response_ids,
    SUM(Response_ID IS NULL) null_response_id,
    SUM(Campaign_ID IS NULL) null_campaign_id,
    SUM(Customer_ID IS NULL) null_customer_id,
    SUM(Response_Date IS NULL OR TRIM(Response_Date)='') null_response_date,
    SUM(Response IS NULL OR TRIM(Response)='') null_response
FROM Campaign_Responses_Raw;

SELECT Response_ID, COUNT(*) duplicate_count
FROM Campaign_Responses_Raw
GROUP BY Response_ID HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, Response_ID;

SELECT DISTINCT Response FROM Campaign_Responses_Raw ORDER BY Response;

-- 8. Referential integrity
SELECT COUNT(*) orders_missing_customer
FROM Orders_Raw o LEFT JOIN Customers_Raw c
ON o.Customer_ID=c.Customer_ID
WHERE o.Customer_ID IS NOT NULL AND c.Customer_ID IS NULL;

SELECT COUNT(*) orders_missing_product
FROM Orders_Raw o LEFT JOIN Products_Raw p
ON o.Product_ID=p.Product_ID
WHERE o.Product_ID IS NOT NULL AND p.Product_ID IS NULL;

SELECT COUNT(*) responses_missing_campaign
FROM Campaign_Responses_Raw r LEFT JOIN Marketing_Campaigns_Raw c
ON r.Campaign_ID=c.Campaign_ID
WHERE r.Campaign_ID IS NOT NULL AND c.Campaign_ID IS NULL;

SELECT COUNT(*) responses_missing_customer
FROM Campaign_Responses_Raw r LEFT JOIN Customers_Raw c
ON r.Customer_ID=c.Customer_ID
WHERE r.Customer_ID IS NOT NULL AND c.Customer_ID IS NULL;
