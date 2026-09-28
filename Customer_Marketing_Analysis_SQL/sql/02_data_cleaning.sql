-- SQL Project #3 - Marketing & Customer Analytics
-- 02_data_cleaning.sql
-- MySQL Workbench

USE marketing_analytics;

DROP TABLE IF EXISTS Campaign_Responses_Clean;
DROP TABLE IF EXISTS Marketing_Campaigns_Clean;
DROP TABLE IF EXISTS Orders_Clean;
DROP TABLE IF EXISTS Products_Clean;
DROP TABLE IF EXISTS Customers_Clean;

-- ============================================================
-- CUSTOMERS
-- Duplicates: keep one row per Customer_ID.
-- Missing Age: median of valid ages.
-- Missing text: Unknown.
-- Country/Gender standardized.
-- ============================================================
CREATE TABLE Customers_Clean AS
WITH ranked AS (
    SELECT
        Customer_ID,
        TRIM(Customer_Name) Customer_Name,
        CASE
            WHEN LOWER(TRIM(Gender)) IN ('male','m') THEN 'Male'
            WHEN LOWER(TRIM(Gender)) IN ('female','f') THEN 'Female'
            ELSE 'Unknown'
        END Gender,
        Age,
        COALESCE(NULLIF(TRIM(City),''),'Unknown') City,
        CASE
            WHEN LOWER(TRIM(Country))='palestine' THEN 'Palestine'
            WHEN LOWER(TRIM(Country))='jordan' THEN 'Jordan'
            WHEN LOWER(TRIM(Country))='egypt' THEN 'Egypt'
            WHEN LOWER(TRIM(Country))='saudi arabia' THEN 'Saudi Arabia'
            ELSE COALESCE(NULLIF(TRIM(Country),''),'Unknown')
        END Country,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY (Customer_Name IS NOT NULL) DESC
        ) rn
    FROM Customers_Raw
    WHERE Customer_ID IS NOT NULL
),
valid_ages AS (
    SELECT Age FROM Customers_Raw
    WHERE Age IS NOT NULL AND Age > 0
),
age_median AS (
    SELECT AVG(Age) median_age
    FROM (
        SELECT Age,
               ROW_NUMBER() OVER (ORDER BY Age) rn,
               COUNT(*) OVER () cnt
        FROM valid_ages
    ) x
    WHERE rn IN (FLOOR((cnt+1)/2), FLOOR((cnt+2)/2))
)
SELECT
    Customer_ID,
    COALESCE(Customer_Name, CONCAT('Customer ',Customer_ID)) Customer_Name,
    Gender,
    COALESCE(Age, (SELECT median_age FROM age_median)) Age,
    City,
    Country
FROM ranked
WHERE rn=1;

ALTER TABLE Customers_Clean ADD PRIMARY KEY (Customer_ID);

-- ============================================================
-- PRODUCTS
-- Keep one row per Product_ID.
-- Invalid negative price/cost -> NULL, then average imputation.
-- ============================================================
CREATE TABLE Products_Clean AS
WITH ranked AS (
    SELECT
        Product_ID,
        COALESCE(NULLIF(TRIM(Product_Name),''),CONCAT('Product ',Product_ID)) Product_Name,
        COALESCE(NULLIF(TRIM(Category),''),'Unknown') Category,
        COALESCE(NULLIF(TRIM(Subcategory),''),'Unknown') Subcategory,
        CASE WHEN Unit_Price >= 0 THEN Unit_Price END Unit_Price,
        CASE WHEN Cost >= 0 THEN Cost END Cost,
        ROW_NUMBER() OVER (
            PARTITION BY Product_ID
            ORDER BY (Product_Name IS NOT NULL) DESC
        ) rn
    FROM Products_Raw
    WHERE Product_ID IS NOT NULL
),
base AS (SELECT * FROM ranked WHERE rn=1)
SELECT
    Product_ID, Product_Name, Category, Subcategory,
    COALESCE(Unit_Price,(SELECT AVG(Unit_Price) FROM base)) Unit_Price,
    COALESCE(Cost,(SELECT AVG(Cost) FROM base)) Cost
FROM base;

ALTER TABLE Products_Clean ADD PRIMARY KEY (Product_ID);

-- ============================================================
-- ORDERS
-- Duplicate Order_ID -> keep one row.
-- Quantity <= 0 or NULL -> median positive quantity.
-- Discount outside 0..1 or NULL -> 0.
-- ============================================================
CREATE TABLE Orders_Clean AS
WITH ranked AS (
    SELECT
        Order_ID, Customer_ID,
        CASE WHEN TRIM(Order_Date)='' THEN NULL
             ELSE STR_TO_DATE(TRIM(Order_Date),'%Y-%m-%d') END Order_Date,
        Product_ID, Quantity, Discount,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID
            ORDER BY (Customer_ID IS NOT NULL) DESC,
                     (Product_ID IS NOT NULL) DESC
        ) rn
    FROM Orders_Raw
    WHERE Order_ID IS NOT NULL
),
base AS (SELECT * FROM ranked WHERE rn=1),
positive_qty AS (
    SELECT Quantity,
           ROW_NUMBER() OVER (ORDER BY Quantity) rn,
           COUNT(*) OVER () cnt
    FROM base
    WHERE Quantity > 0
),
median_qty AS (
    SELECT AVG(Quantity) median_quantity
    FROM positive_qty
    WHERE rn IN (FLOOR((cnt+1)/2),FLOOR((cnt+2)/2))
)
SELECT
    Order_ID, Customer_ID, Order_Date, Product_ID,
    COALESCE(NULLIF(Quantity,0),
             (SELECT median_quantity FROM median_qty), 5) Quantity,
    CASE WHEN Discount BETWEEN 0 AND 1 THEN Discount ELSE 0 END Discount
FROM base;

ALTER TABLE Orders_Clean ADD PRIMARY KEY (Order_ID);
CREATE INDEX idx_orders_customer ON Orders_Clean(Customer_ID);
CREATE INDEX idx_orders_product ON Orders_Clean(Product_ID);

-- ============================================================
-- CAMPAIGNS
-- One row per Campaign_ID.
-- Negative budget -> NULL, then average valid budget.
-- ============================================================
CREATE TABLE Marketing_Campaigns_Clean AS
WITH ranked AS (
    SELECT
        Campaign_ID,
        COALESCE(NULLIF(TRIM(Campaign_Name),''),CONCAT('Campaign ',Campaign_ID)) Campaign_Name,
        COALESCE(NULLIF(TRIM(Campaign_Type),''),'Unknown') Campaign_Type,
        CASE WHEN TRIM(Start_Date)='' THEN NULL
             ELSE STR_TO_DATE(TRIM(Start_Date),'%Y-%m-%d') END Start_Date,
        CASE WHEN TRIM(End_Date)='' THEN NULL
             ELSE STR_TO_DATE(TRIM(End_Date),'%Y-%m-%d') END End_Date,
        CASE WHEN Budget >= 0 THEN Budget END Budget,
        ROW_NUMBER() OVER (
            PARTITION BY Campaign_ID
            ORDER BY (Budget IS NOT NULL) DESC
        ) rn
    FROM Marketing_Campaigns_Raw
    WHERE Campaign_ID IS NOT NULL
),
base AS (SELECT * FROM ranked WHERE rn=1)
SELECT
    Campaign_ID, Campaign_Name, Campaign_Type,
    Start_Date, End_Date,
    COALESCE(Budget,(SELECT AVG(Budget) FROM base)) Budget
FROM base;

ALTER TABLE Marketing_Campaigns_Clean ADD PRIMARY KEY (Campaign_ID);

-- ============================================================
-- CAMPAIGN RESPONSES
-- One row per Response_ID.
-- ============================================================
CREATE TABLE Campaign_Responses_Clean AS
WITH ranked AS (
    SELECT
        Response_ID, Campaign_ID, Customer_ID,
        CASE WHEN TRIM(Response_Date)='' THEN NULL
             ELSE STR_TO_DATE(TRIM(Response_Date),'%Y-%m-%d') END Response_Date,
        CASE
            WHEN LOWER(TRIM(Response)) IN
                 ('responded','response','yes','y','converted','conversion')
                THEN 'Responded'
            WHEN LOWER(TRIM(Response)) IN
                 ('no response','no','n','not responded')
                THEN 'No Response'
            ELSE COALESCE(NULLIF(TRIM(Response),''),'Unknown')
        END Response,
        ROW_NUMBER() OVER (
            PARTITION BY Response_ID
            ORDER BY (Campaign_ID IS NOT NULL) DESC,
                     (Customer_ID IS NOT NULL) DESC
        ) rn
    FROM Campaign_Responses_Raw
    WHERE Response_ID IS NOT NULL
)
SELECT Response_ID, Campaign_ID, Customer_ID, Response_Date, Response
FROM ranked WHERE rn=1;

ALTER TABLE Campaign_Responses_Clean ADD PRIMARY KEY (Response_ID);
CREATE INDEX idx_response_campaign ON Campaign_Responses_Clean(Campaign_ID);
CREATE INDEX idx_response_customer ON Campaign_Responses_Clean(Customer_ID);

-- ============================================================
-- CLEANING QA
-- ============================================================
SELECT 'Customers_Clean' table_name, COUNT(*) rows_count FROM Customers_Clean
UNION ALL SELECT 'Products_Clean',COUNT(*) FROM Products_Clean
UNION ALL SELECT 'Orders_Clean',COUNT(*) FROM Orders_Clean
UNION ALL SELECT 'Marketing_Campaigns_Clean',COUNT(*) FROM Marketing_Campaigns_Clean
UNION ALL SELECT 'Campaign_Responses_Clean',COUNT(*) FROM Campaign_Responses_Clean;

SELECT
    SUM(Quantity <= 0) bad_quantity,
    SUM(Discount < 0 OR Discount > 1) bad_discount,
    SUM(Order_Date IS NULL) missing_order_date
FROM Orders_Clean;
