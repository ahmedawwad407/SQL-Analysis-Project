-- E-Commerce Sales Analysis
-- 01 - Data Cleaning

CREATE DATABASE IF NOT EXISTS ecommerce_sales_analysis;
USE ecommerce_sales_analysis;

-- =========================================================
-- 1. ORDERS STAGING
-- =========================================================

DROP TABLE IF EXISTS Orders_Staging;

CREATE TABLE Orders_Staging LIKE Orders;

ALTER TABLE Orders_Staging
ADD COLUMN row_num INT;

INSERT INTO Orders_Staging
SELECT
    Order_ID,
    Customer_ID,
    CASE
        WHEN Order_Date = '0000-00-00 00:00:00' THEN NULL
        ELSE Order_Date
    END AS Order_Date,
    Product_ID,
    Quantity,
    Discount,
    ROW_NUMBER() OVER (
        PARTITION BY Order_ID, Customer_ID, Order_Date, Product_ID, Quantity, Discount
    ) AS row_num
FROM Orders;

-- Remove duplicate records
DELETE FROM Orders_Staging
WHERE row_num > 1;

-- Invalid quantities: set <= 0 to NULL
UPDATE Orders_Staging
SET Quantity = NULL
WHERE Quantity <= 0;

-- Median valid quantity used for imputation = 5
UPDATE Orders_Staging
SET Quantity = 5
WHERE Quantity IS NULL;

-- Invalid discounts: set values outside 0-1 to NULL
UPDATE Orders_Staging
SET Discount = NULL
WHERE Discount < 0 OR Discount > 1;

-- Missing discounts are treated as 0
UPDATE Orders_Staging
SET Discount = 0
WHERE Discount IS NULL;


-- =========================================================
-- 2. CUSTOMERS STAGING
-- =========================================================

DROP TABLE IF EXISTS Customers_Staging;

CREATE TABLE Customers_Staging LIKE Customers;

INSERT INTO Customers_Staging
SELECT *
FROM Customers;

-- Remove duplicate Customer_ID records.
-- Keep the first occurrence of each Customer_ID.
DELETE c
FROM Customers_Staging c
JOIN (
    SELECT Customer_ID,
           ROW_NUMBER() OVER (
               PARTITION BY Customer_ID
               ORDER BY Customer_ID
           ) AS rn
    FROM Customers_Staging
) d
ON c.Customer_ID = d.Customer_ID
AND d.rn > 1;

-- Remove accidentally loaded rows outside the customer ID range
DELETE FROM Customers_Staging
WHERE Customer_ID NOT BETWEEN 1001 AND 1500;

-- Invalid age = 0 -> NULL
UPDATE Customers_Staging
SET Age = NULL
WHERE Age = 0;

-- Median age used for imputation = 42
UPDATE Customers_Staging
SET Age = 42
WHERE Age IS NULL;

-- Standardize Gender
UPDATE Customers_Staging
SET Gender = 'Male'
WHERE TRIM(Gender) = 'M';

UPDATE Customers_Staging
SET Gender = TRIM(Gender);

UPDATE Customers_Staging
SET Gender = NULL
WHERE Gender = '';

UPDATE Customers_Staging
SET Gender = 'Male'
WHERE Gender IS NULL;

-- Standardize City
UPDATE Customers_Staging
SET City = TRIM(City);

UPDATE Customers_Staging
SET City = NULL
WHERE City = '';

-- Mode city was used where needed: Gaza
UPDATE Customers_Staging
SET City = 'Gaza'
WHERE City IS NULL;

-- Standardize Country
UPDATE Customers_Staging
SET Country = TRIM(Country);

UPDATE Customers_Staging
SET Country = NULL
WHERE Country = '';

-- Mode country was used where needed: Egypt
UPDATE Customers_Staging
SET Country = 'Egypt'
WHERE Country IS NULL;


-- =========================================================
-- 3. PRODUCTS STAGING
-- =========================================================

DROP TABLE IF EXISTS Products_Staging;

CREATE TABLE Products_Staging LIKE Products;

INSERT INTO Products_Staging
SELECT *
FROM Products;

-- Standardize category
UPDATE Products_Staging
SET Category = 'Home & Kitchen'
WHERE TRIM(Category) = 'Home and Kitchen';

-- Standardize subcategory
UPDATE Products_Staging
SET Subcategory = TRIM(Subcategory);

UPDATE Products_Staging
SET Subcategory = 'Phones'
WHERE LOWER(Subcategory) = 'phones';

UPDATE Products_Staging
SET Subcategory = NULL
WHERE Subcategory = '';

-- Mode subcategory used for missing values: Phones
UPDATE Products_Staging
SET Subcategory = 'Phones'
WHERE Subcategory IS NULL;

-- Invalid negative Unit_Price -> NULL
UPDATE Products_Staging
SET Unit_Price = NULL
WHERE Unit_Price < 0;

-- Median Unit_Price used for imputation = 666
UPDATE Products_Staging
SET Unit_Price = 666
WHERE Unit_Price IS NULL;

-- Zero Unit_Price -> NULL, then impute
UPDATE Products_Staging
SET Unit_Price = NULL
WHERE Unit_Price = 0;

UPDATE Products_Staging
SET Unit_Price = 666
WHERE Unit_Price IS NULL;

-- Invalid negative Cost -> NULL
UPDATE Products_Staging
SET Cost = NULL
WHERE Cost < 0;

-- Median Cost used for imputation = 426.57
UPDATE Products_Staging
SET Cost = 426.57
WHERE Cost IS NULL;

-- Zero Cost -> NULL, then impute
UPDATE Products_Staging
SET Cost = NULL
WHERE Cost = 0;

UPDATE Products_Staging
SET Cost = 426.57
WHERE Cost IS NULL;
