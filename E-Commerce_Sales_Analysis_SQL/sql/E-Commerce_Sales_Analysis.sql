use ecommerceproject2;
-- Check Data
select * from customers;
select * from products;
select * from orders;

SELECT COUNT(*) AS Total_Customers
FROM customers;

SELECT COUNT(*) AS Total_Products
FROM products;

SELECT COUNT(*) AS Total_Orders
FROM orders;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers';

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

-- check null values
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN ï»؟Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_NULL,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_NULL
FROM customers;

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN ï»؟Product_ID IS NULL THEN 1 ELSE 0 END) AS Product_ID_NULL,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Unit_Price_NULL,
    SUM(CASE WHEN Cost IS NULL THEN 1 ELSE 0 END) AS Cost_NULL
FROM products;

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN ï»؟Order_ID IS NULL THEN 1 ELSE 0 END) AS Order_ID_NULL,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_NULL,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Product_ID_NULL,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_NULL,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS Discount_NULL,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Order_Date_NULL
FROM orders;

-- check duplicate
SELECT 
    ï»؟Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY ï»؟Customer_ID
HAVING COUNT(*) > 1;

SELECT 
    ï»؟Product_ID,
    COUNT(*) AS Duplicate_Count
FROM products
GROUP BY ï»؟Product_ID
HAVING COUNT(*) > 1;

select
	ï»؟Order_ID,
    COUNT(*) as Duplicate_Count
    from orders
    group by ï»؟Order_ID
    having  COUNT(*) > 1;
    
-- Get Duplicate
SELECT *
FROM customers
WHERE ï»؟Customer_ID IN (1018, 1089, 1146, 1222)
ORDER BY ï»؟Customer_ID;

-- sure All row same duplicate 
SELECT 
    ï»؟Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY 
    ï»؟Customer_ID,
    Customer_Name,
    Gender,
    Age,
    City,
    Country
HAVING COUNT(*) > 1;

SELECT *
FROM products
WHERE ï»؟Product_ID IN (2011, 2041, 2074)
ORDER BY ï»؟Product_ID;

SELECT 
    ï»؟Product_ID,
    COUNT(*) AS Duplicate_Count
FROM products
GROUP BY 
    ï»؟Product_ID,
    Product_Name,
    Category,
    Subcategory,
    Unit_Price,
    Cost
HAVING COUNT(*) > 1;


select
	ï»؟Order_ID,
    COUNT(*) as Duplicate_Count
    from orders
    group by ï»؟Order_ID
    having  COUNT(*) > 1;
    
    SELECT *
FROM orders
WHERE ï»؟Order_ID IN (50101, 50356, 50778, 51101, 51451)
ORDER BY ï»؟Order_ID;

SELECT 
    ï»؟Order_ID ,
    COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY 
    ï»؟Order_ID,
    Customer_ID,
    Order_Date,
    Product_ID,
    Quantity,
    Discount
HAVING COUNT(*) > 1;

-- Clean Duplicate Values After Sure
WITH Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ï»؟Customer_ID, Customer_Name, Gender, Age, City, Country
               ORDER BY ï»؟Customer_ID
           ) AS row_num
    FROM customers
)
DELETE FROM Duplicates
WHERE row_num > 1;

WITH Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ï»؟Product_ID, Product_Name, Category, Unit_Price, Cost
               ORDER BY ï»؟Product_ID
           ) AS row_num
    FROM products
)
DELETE FROM Duplicates
WHERE row_num > 1;

CREATE TABLE Customers_Staging LIKE customers;

ALTER TABLE Customers_Staging
ADD COLUMN row_num INT;

INSERT INTO Customers_Staging
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY
               ï»؟Customer_ID,
               Customer_Name,
               Gender,
               Age,
               City,
               Country
       ) AS row_num
FROM customers;

SELECT *
FROM Customers_Staging
WHERE row_num > 1;

DELETE FROM Customers_Staging
WHERE row_num > 1;



CREATE TABLE Customers_Staging2 LIKE products;

ALTER TABLE Customers_Staging2
ADD COLUMN row_num INT;


INSERT INTO Customers_Staging2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY
               ï»؟Product_ID,
               Product_Name,
               Category,
			   Subcategory,
			   Unit_Price,
			   Cost
       ) AS row_num
FROM products;

SELECT *
FROM Customers_Staging2
WHERE row_num > 1;

DELETE FROM Customers_Staging2
WHERE row_num > 1;

# SHOW WARNINGS;

CREATE TABLE Orders_Staging LIKE Orders;

ALTER TABLE Orders_Staging
ADD COLUMN row_num INT;

INSERT INTO Orders_Staging
SELECT
    ï»؟Order_ID,
    Customer_ID,
    CASE
        WHEN Order_Date = '0000-00-00 00:00:00' THEN NULL
        ELSE Order_Date
    END AS Order_Date,
    Product_ID,
    Quantity,
    Discount,
    ROW_NUMBER() OVER (
        PARTITION BY
        ï»؟Order_ID,
    Customer_ID,
    Order_Date,
    Product_ID,
    Quantity,
    Discount
    
    ) AS row_num
FROM Orders;

SELECT 
    COUNT(*) AS Invalid_Dates
FROM Orders_Staging
WHERE Order_Date IS NULL;

SELECT *
FROM orders_staging
WHERE row_num > 1;

DELETE FROM orders_staging
WHERE row_num > 1;

SELECT COUNT(*) AS Total_Rows
FROM Orders_Staging;

-- Data Validation
-- Orders Table
# SELECT 
#     ï»؟Order_ID,
#     Order_Date
# FROM Orders
# WHERE ï»؟Order_ID IN (
#     SELECT ï»؟Order_ID
#     FROM Orders
#     WHERE Order_Date IS NULL
# );

SELECT 
    MIN(Order_Date) AS Min_Date,
    MAX(Order_Date) AS Max_Date
FROM orders_staging;

SELECT 
    COUNT(*) AS Invalid_Date_Rows
FROM Orders
WHERE Order_Date = '0000-00-00 00:00:00';
SELECT 
    ï»؟Order_ID,
    Order_Date
FROM Orders
WHERE Order_Date = '0000-00-00 00:00:00';


UPDATE Orders_Staging
SET Order_Date = NULL
WHERE Order_Date = '0000-00-00 00:00:00';

SELECT *
FROM Orders_Staging
WHERE Quantity <= 0;

SELECT
    MIN(Quantity) AS Min_Quantity,
    MAX(Quantity) AS Max_Quantity,
    AVG(Quantity) AS Avg_Quantity,
    COUNT(*) AS Total_Rows
FROM Orders_Staging
WHERE Quantity > 0;

UPDATE Orders_Staging
SET Quantity = NULL
WHERE Quantity <= 0;


SELECT *
FROM Orders_Staging
WHERE Discount < 0
   OR Discount > 1;
   
UPDATE Orders_Staging
SET Discount = NULL
WHERE Discount < 0 OR Discount > 1;

SELECT
    MIN(Order_Date) AS Min_Order_Date,
    MAX(Order_Date) AS Max_Order_Date,
    COUNT(*) AS Total_Rows,
    COUNT(Order_Date) AS Valid_Dates,
    COUNT(*) - COUNT(Order_Date) AS Missing_Dates
FROM Orders_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(ï»؟Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Discount IS NULL) AS Missing_Discount,
	SUM(Quantity <= 0) AS Invalid_Quantity,
    SUM(Discount < 0 OR Discount > 1) AS Invalid_Discount
FROM Orders_Staging;

-- Customer Table
SELECT
    MIN(Age) AS Min_Age,
    MAX(Age) AS Max_Age,
    AVG(Age) AS Avg_Age
FROM Customers_Staging;

SELECT *
FROM Customers_Staging
WHERE Age = 0;

UPDATE Customers_Staging
SET Age = NULL
WHERE Age = 0;

SELECT
    City,
    COUNT(*) AS Frequency
FROM Customers_Staging
GROUP BY City
ORDER BY Frequency DESC;

UPDATE Customers_Staging
SET City = TRIM(City);

SELECT
    Gender,
    COUNT(*) AS Frequency
FROM Customers_Staging
GROUP BY Gender
ORDER BY Frequency DESC;

SELECT
    Country,
    COUNT(*) AS Frequency
FROM Customers_Staging
GROUP BY Country
ORDER BY Frequency DESC;

UPDATE Customers_Staging
SET Country = NULL
WHERE Country = '';

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT ï»؟Customer_ID) AS Unique_Customers,
    SUM(ï»؟Customer_ID IS NULL) AS Missing_ID,
    SUM(Customer_Name IS NULL) AS Missing_Name,
    SUM(Gender IS NULL) AS Missing_Gender,
    SUM(Age IS NULL) AS Missing_Age,
    SUM(City IS NULL) AS Missing_City,
    SUM(Country IS NULL) AS Missing_Country,
    SUM(Age < 18 OR Age > 65) AS Invalid_Age
FROM Customers_Staging;

-- Check RelationShip
SELECT o.Customer_ID
FROM Orders_Staging o
LEFT JOIN Customers_Staging c
    ON o.Customer_ID = c.ï»؟Customer_ID
WHERE c.ï»؟Customer_ID IS NULL;

SELECT o.Product_ID
FROM Orders_Staging o
LEFT JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
WHERE p.ï»؟Product_ID IS NULL;

# ALTER TABLE customers_staging2 RENAME Products_Staging;

-- Missing Values (Null)
-- Check Orders table
SELECT *
FROM Orders_Staging
WHERE Order_Date IS NULL;

SELECT
    Order_Date,
    COUNT(*) AS Frequency
FROM Orders_Staging
WHERE Order_Date IS NOT NULL
GROUP BY Order_Date
ORDER BY Frequency DESC;



UPDATE Orders_Staging
SET Order_Date = '2025-11-14 00:00:00'
WHERE Order_Date IS NULL;

SELECT COUNT(*) AS Missing_OrderDate
FROM Orders_Staging
WHERE Order_Date IS NULL;
 
SELECT
    COUNT(*) AS Total_Rows,
    SUM(ï»؟Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Discount IS NULL) AS Missing_Discount,
	SUM(Quantity <= 0) AS Invalid_Quantity,
    SUM(Discount < 0 OR Discount > 1) AS Invalid_Discount
FROM Orders_Staging;

SELECT
    Discount,
    COUNT(*) AS Frequency
FROM Orders_Staging
WHERE Discount IS NOT NULL
GROUP BY Discount
ORDER BY Frequency DESC;

UPDATE Orders_Staging
SET Discount = 0
WHERE Discount IS NULL;

SELECT
    Quantity,
    COUNT(*) AS Frequency
FROM Orders_Staging
WHERE Quantity IS NOT NULL
GROUP BY Quantity
ORDER BY Frequency DESC;

SELECT
    AVG(Quantity) AS Median_Quantity
FROM (
    SELECT
			Quantity,
        ROW_NUMBER() OVER (ORDER BY Quantity) AS Row_Num,
        COUNT(*) OVER () AS Total_Rows
    FROM Orders_Staging
    WHERE Quantity IS NOT NULL
) AS q
WHERE Row_Num IN (
    FLOOR((Total_Rows + 1) / 2),
    CEIL((Total_Rows + 1) / 2)
);

UPDATE Orders_Staging
SET Quantity = 5
WHERE Quantity IS NULL;

SELECT COUNT(*) AS Missing_Quantity
FROM Orders_Staging
WHERE Quantity IS NULL;

-- Check Customer table
SELECT
    COUNT(*) AS Total_Rows,
    SUM(ï»؟Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Customer_Name IS NULL) AS Missing_Customer_Name,
    SUM(Gender IS NULL) AS Missing_Gender,
    SUM(Age IS NULL) AS Missing_Age,
    SUM(City IS NULL) AS Missing_City,
    SUM(Country IS NULL) AS Missing_Country
FROM Customers_Staging;


SELECT *
FROM Customers_Staging
WHERE Age is null;

SELECT
    Age,
    COUNT(*) AS Frequency
FROM Customers_Staging
WHERE Age IS NOT NULL
GROUP BY Age
ORDER BY Frequency DESC;

SELECT
    AVG(Age) AS Median_Age
FROM (
    SELECT
        Age,
        ROW_NUMBER() OVER (ORDER BY Age) AS Row_Num,
        COUNT(*) OVER () AS Total_Rows
    FROM Customers_Staging
    WHERE Age IS NOT NULL
) AS c
WHERE Row_Num IN (
    FLOOR((Total_Rows + 1) / 2),
    CEIL((Total_Rows + 1) / 2)
);

UPDATE Customers_Staging
SET Age = 42
WHERE Age IS NULL;


SELECT *
FROM Customers_Staging
WHERE Gender NOT IN ('Male', 'Female', 'M')
   OR Gender IS NULL;
   
SELECT
    Gender,
    COUNT(*) AS Frequency
FROM Customers_Staging
WHERE Gender IN ('Male', 'Female', 'M')
GROUP BY Gender
ORDER BY Frequency DESC;

SELECT
    ï»؟Customer_ID,
    Customer_Name,
    Gender,
    Age,
    City,
    Country
FROM Customers_Staging
WHERE Gender ='';

UPDATE Customers_Staging
SET Gender = 'Male'
WHERE Gender is null;

SELECT
    COUNT(*) AS Missing_Gender
FROM Customers_Staging
WHERE Gender IS NULL;

SELECT
    ï»؟Customer_ID,
    Customer_Name,
    Gender,
    Age,
    City,
    Country
FROM Customers_Staging
WHERE City = '';

UPDATE Customers_Staging
SET City = 'Gaza'
WHERE City is null;

SELECT
    COUNT(*) AS Missing_City
FROM Customers_Staging
WHERE city IS NULL;

UPDATE Customers_Staging
SET Country = 'Egypt'
WHERE Country is null;

SELECT COUNT(*) AS Missing_Country
FROM Customers_Staging
WHERE Country IS NULL;

-- Normalization
UPDATE Customers_Staging
SET Gender = 'Male'
WHERE Gender = 'M';

SELECT Gender, COUNT(*) AS Frequency
FROM Customers_Staging
GROUP BY Gender
ORDER BY Frequency DESC;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(ï»؟Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Customer_Name IS NULL) AS Missing_Customer_Name,
    SUM(Gender IS NULL) AS Missing_Gender,
    SUM(Age IS NULL) AS Missing_Age,
    SUM(City IS NULL) AS Missing_City,
    SUM(Country IS NULL) AS Missing_Country,
    COUNT(DISTINCT ï»؟Customer_ID) AS Unique_Customers
FROM Customers_Staging;

-- Check Product table
DESCRIBE Products;

SELECT COUNT(*) AS Total_Rows
FROM Products_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(ï»؟Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Product_Name IS NULL) AS Missing_Product_Name,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Subcategory IS NULL) AS Missing_Subcategory,
    SUM(Unit_Price IS NULL) AS Missing_Unit_Price,
    SUM(Cost IS NULL) AS Missing_Cost
FROM Products_Staging;

SELECT
    ï»؟Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Products_Staging
GROUP BY ï»؟Product_ID
HAVING COUNT(*) > 1;

SELECT
    Product_Name,
    COUNT(*) AS Name_Count
FROM Products_Staging
GROUP BY Product_Name
HAVING COUNT(*) > 1;

SELECT
    Category,
    COUNT(*) AS Product_Count
FROM Products_Staging
GROUP BY Category
ORDER BY Product_Count DESC;

UPDATE Products_Staging
SET Category = 'Home & Kitchen'
WHERE Category = 'Home and Kitchen';

select count(*) as CategoryCount
from Products_Staging
where Category = 'Home and Kitchen';

SELECT
    Subcategory,
    COUNT(*) AS Product_Count
FROM Products_Staging
GROUP BY Subcategory
ORDER BY Product_Count DESC;


UPDATE Products_Staging
SET Subcategory = 'Phones'
WHERE TRIM(Subcategory) = 'phones';


SELECT
    Subcategory,
    COUNT(*) AS Frequency
FROM Products_Staging
GROUP BY Subcategory
ORDER BY Frequency DESC;


UPDATE Products_Staging
SET Subcategory = 'Phones'
WHERE Subcategory ='';

SELECT
    MIN(Unit_Price) AS Min_Unit_Price,
    MAX(Unit_Price) AS Max_Unit_Price,
    AVG(Unit_Price) AS Avg_Unit_Price,
    MIN(Cost) AS Min_Cost,
    MAX(Cost) AS Max_Cost,
    AVG(Cost) AS Avg_Cost
FROM Products_Staging;

SELECT
    ï»؟Product_ID,
    Product_Name,
    Category,
    Subcategory,
    Unit_Price,
    Cost
FROM Products_Staging
WHERE Unit_Price <= 0
   OR Cost <= 0;

SELECT AVG(Unit_Price) AS Median_Unit_Price
FROM (
    SELECT
        Unit_Price,
        ROW_NUMBER() OVER (ORDER BY Unit_Price) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM Products_Staging
    WHERE Unit_Price >= 0
) AS x
WHERE rn IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
);

UPDATE Products_Staging
SET Unit_Price = 666
WHERE Unit_Price <= 0;

SELECT AVG(Cost) AS Median_Cost
FROM (
    SELECT
        Cost,
        ROW_NUMBER() OVER (ORDER BY Cost) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM Products_Staging
    WHERE Cost >= 0
) AS x
WHERE rn IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
);


UPDATE Products_Staging
SET Cost = 426.57
WHERE Cost <= 0;

SELECT
    MIN(Unit_Price) AS Min_Unit_Price,
    MIN(Cost) AS Min_Cost
FROM Products_Staging;

SELECT
    MIN(Unit_Price) AS Min_Unit_Price,
    MAX(Unit_Price) AS Max_Unit_Price,
    MIN(Cost) AS Min_Cost,
    MAX(Cost) AS Max_Cost,
    SUM(Unit_Price IS NULL or Unit_Price <=0) AS Missing_Unit_Price,
    SUM(Cost IS NULL or Cost <=0) AS Missing_Cost
FROM Products_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT ï»؟Product_ID) AS Unique_Products,

    SUM(ï»؟Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Product_Name IS NULL) AS Missing_Product_Name,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Subcategory IS NULL) AS Missing_Subcategory,
    SUM(Unit_Price IS NULL) AS Missing_Unit_Price,
    SUM(Cost IS NULL) AS Missing_Cost,

    SUM(Unit_Price <= 0) AS Invalid_Unit_Price,
    SUM(Cost <= 0) AS Invalid_Cost,

    SUM(Cost > Unit_Price) AS Negative_Margin_Rows
FROM Products_Staging;

--  ِAnalysis (KPI)

-- Check Join
select
 o.ï»؟Order_ID,
    o.Order_Date,
    c.Customer_Name,
    p.Product_Name,
    p.Category,
    o.Quantity,
    p.Unit_Price,
    o.Discount
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.ï»؟Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
LIMIT 10;

-- Q1 Total Revenue
SELECT
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID;

-- Q2 Total Cost
SELECT
    ROUND(
        SUM(p.Cost * o.Quantity),
        2
    ) AS Total_Cost
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID;
    
-- Q3 Total Profit
    SELECT
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),2
        
    ) AS Total_Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID;
    
--  Q4 Profit Margin
SELECT
    ROUND(
        (
            SUM(
                (p.Unit_Price * o.Quantity * (1 - o.Discount))
                - (p.Cost * o.Quantity)
            )
            / SUM(
                p.Unit_Price * o.Quantity * (1 - o.Discount)
            )
        ) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID;

-- Q6 Which category generates the highest revenue?
SELECT
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;

-- Q7 Which category generates the highest profit?
SELECT
    p.Category,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Total_Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY p.Category
ORDER BY Total_Profit DESC;

-- Q8 Profit Margin by Category
SELECT
    p.Category,
    ROUND(
        (
            SUM(
                (p.Unit_Price * o.Quantity * (1 - o.Discount))
                - (p.Cost * o.Quantity)
            )
            /
            SUM(
                p.Unit_Price * o.Quantity * (1 - o.Discount)
            )
        ) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY p.Category
ORDER BY Profit_Margin_Percentage DESC;

-- Q9 Were sales stronger in 2024 or 2025?
SELECT
    YEAR(o.Order_Date) AS Order_Year,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY YEAR(o.Order_Date)
ORDER BY Total_Revenue desc;

-- Q10 Were sales stronger in Months?

SELECT
    MONTH(o.Order_Date) AS Order_Month,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY MONTH(o.Order_Date)
ORDER BY Total_Revenue DESC;

-- Q11 Who are the customers with the highest purchase volume? (Top 10 Customers by Revenue) 
SELECT
    c.ï»؟Customer_ID,
    c.Customer_Name,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.ï»؟Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY
    c.ï»؟Customer_ID,
    c.Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q12 Top products by revenue
SELECT
    p.ï»؟Product_ID,
    p.Product_Name,
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY
    p.ï»؟Product_ID,
    p.Product_Name,
    p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q13 Top 10 Products by Profit
SELECT
    p.ï»؟Product_ID,
    p.Product_Name,
    p.Category,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Total_Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY
    p.ï»؟Product_ID,
    p.Product_Name,
    p.Category
ORDER BY Total_Profit DESC
LIMIT 10;

-- Q14 Which customers buy the most in terms of quantity?
SELECT
    c.ï»؟Customer_ID,
    c.Customer_Name,
    SUM(o.Quantity) AS Total_Quantity
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.ï»؟Customer_ID
GROUP BY
    c.ï»؟Customer_ID,
    c.Customer_Name
ORDER BY Total_Quantity DESC
LIMIT 10;

-- Q15 How much does the store earn on average from each order? Average Order Value (AOV)
SELECT
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount))
        / COUNT(DISTINCT o.ï»؟Order_ID),
        2
    ) AS Average_Order_Value
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID;
    
-- Q16 Average Order Value by Category
SELECT
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount))
        / COUNT(DISTINCT o.ï»؟Order_ID),
        2
    ) AS Average_Order_Value
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY p.Category
ORDER BY Average_Order_Value DESC;

-- Q17 Revenue by Discount
SELECT
    o.Discount,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY o.Discount
ORDER BY o.Discount;

-- Q18 Profit by Discount.
SELECT
    o.Discount,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Total_Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY o.Discount
ORDER BY o.Discount;

-- Q19 Revenue by Country
SELECT
    c.Country,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Total_Revenue
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.ï»؟Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY c.Country
ORDER BY Total_Revenue DESC;

-- Q20 Count of Orders by Categotry
SELECT
    p.Category,
    COUNT(DISTINCT o.ï»؟Order_ID) AS Total_Orders
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
GROUP BY p.Category
ORDER BY Total_Orders DESC;

-- Q21 Revenue by Year + Month
SELECT
    YEAR(o.Order_Date) AS Year,
    MONTH(o.Order_Date) AS Month,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.ï»؟Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    Year,
    Month;