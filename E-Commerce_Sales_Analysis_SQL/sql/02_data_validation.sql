-- E-Commerce Sales Analysis
-- 02 - Data Validation

USE ecommerce_sales_analysis;

-- =========================================================
-- ORDERS QUALITY CHECK
-- =========================================================

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Order_ID) AS NonNull_Order_ID,
    COUNT(Customer_ID) AS NonNull_Customer_ID,
    COUNT(Order_Date) AS NonNull_Order_Date,
    COUNT(Product_ID) AS NonNull_Product_ID,
    COUNT(Quantity) AS NonNull_Quantity,
    COUNT(Discount) AS NonNull_Discount
FROM Orders_Staging;

SELECT COUNT(*) AS Invalid_Quantity
FROM Orders_Staging
WHERE Quantity <= 0;

SELECT COUNT(*) AS Invalid_Discount
FROM Orders_Staging
WHERE Discount < 0 OR Discount > 1;

SELECT Order_ID, Order_Date
FROM Orders_Staging
WHERE Order_Date IS NULL
ORDER BY Order_ID;


-- =========================================================
-- CUSTOMERS QUALITY CHECK
-- =========================================================

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(Customer_Name) AS NonNull_Name,
    COUNT(Gender) AS NonNull_Gender,
    COUNT(Age) AS NonNull_Age,
    COUNT(City) AS NonNull_City,
    COUNT(Country) AS NonNull_Country
FROM Customers_Staging;

SELECT COUNT(*) AS Invalid_Age
FROM Customers_Staging
WHERE Age < 18 OR Age > 65;

SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customers_Staging
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- =========================================================
-- PRODUCTS QUALITY CHECK
-- =========================================================

SELECT
    COUNT(*) AS Total_Products,
    COUNT(DISTINCT Product_ID) AS Unique_Products,
    COUNT(Product_Name) AS NonNull_Product_Name,
    COUNT(Category) AS NonNull_Category,
    COUNT(Subcategory) AS NonNull_Subcategory,
    COUNT(Unit_Price) AS NonNull_Unit_Price,
    COUNT(Cost) AS NonNull_Cost
FROM Products_Staging;

SELECT COUNT(*) AS Invalid_Unit_Price
FROM Products_Staging
WHERE Unit_Price <= 0;

SELECT COUNT(*) AS Invalid_Cost
FROM Products_Staging
WHERE Cost <= 0;

SELECT Product_ID, Product_Name, Unit_Price, Cost
FROM Products_Staging
WHERE Cost > Unit_Price;


-- =========================================================
-- REFERENTIAL INTEGRITY
-- =========================================================

-- Orders with missing customer references
SELECT COUNT(*) AS Missing_Customer_References
FROM Orders_Staging o
LEFT JOIN Customers_Staging c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- Orders with missing product references
SELECT COUNT(*) AS Missing_Product_References
FROM Orders_Staging o
LEFT JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- =========================================================
-- JOIN VALIDATION
-- =========================================================

SELECT
    o.Order_ID,
    o.Order_Date,
    c.Customer_Name,
    p.Product_Name,
    p.Category,
    o.Quantity,
    p.Unit_Price,
    o.Discount
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
LIMIT 10;
