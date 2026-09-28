-- E-Commerce Sales Analysis
-- 03 - Business Analysis

USE ecommerce_sales_analysis;

-- =========================================================
-- 1. OVERALL KPIs
-- =========================================================

SELECT
    ROUND(SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)), 2) AS Total_Revenue,
    ROUND(SUM(p.Cost * o.Quantity), 2) AS Total_Cost,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Total_Profit,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        )
        / SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)) * 100,
        2
    ) AS Profit_Margin_Percent,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount))
        / COUNT(DISTINCT o.Order_ID),
        2
    ) AS Average_Order_Value
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID;


-- =========================================================
-- 2. REVENUE BY CATEGORY
-- =========================================================

SELECT
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;


-- =========================================================
-- 3. PROFIT BY CATEGORY
-- =========================================================

SELECT
    p.Category,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit DESC;


-- =========================================================
-- 4. PROFIT MARGIN BY CATEGORY
-- =========================================================

SELECT
    p.Category,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        )
        / SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)) * 100,
        2
    ) AS Profit_Margin_Percent
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit_Margin_Percent DESC;


-- =========================================================
-- 5. REVENUE BY YEAR
-- =========================================================

SELECT
    YEAR(o.Order_Date) AS Year,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY YEAR(o.Order_Date)
ORDER BY Year;


-- =========================================================
-- 6. REVENUE BY MONTH
-- =========================================================

SELECT
    MONTH(o.Order_Date) AS Month,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY MONTH(o.Order_Date)
ORDER BY Revenue DESC;


-- =========================================================
-- 7. TOP 10 CUSTOMERS BY REVENUE
-- =========================================================

SELECT
    c.Customer_ID,
    c.Customer_Name,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Revenue DESC
LIMIT 10;


-- =========================================================
-- 8. TOP 10 PRODUCTS BY REVENUE
-- =========================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Revenue DESC
LIMIT 10;


-- =========================================================
-- 9. TOP 10 PRODUCTS BY PROFIT
-- =========================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Profit DESC
LIMIT 10;


-- =========================================================
-- 10. TOP 10 CUSTOMERS BY QUANTITY
-- =========================================================

SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Quantity) AS Total_Quantity
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Quantity DESC
LIMIT 10;


-- =========================================================
-- 11. AVERAGE ORDER VALUE
-- =========================================================

SELECT
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount))
        / COUNT(DISTINCT o.Order_ID),
        2
    ) AS Average_Order_Value
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID;


-- =========================================================
-- 12. AOV BY CATEGORY
-- =========================================================

SELECT
    p.Category,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount))
        / COUNT(DISTINCT o.Order_ID),
        2
    ) AS AOV
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY AOV DESC;


-- =========================================================
-- 13. REVENUE BY DISCOUNT
-- =========================================================

SELECT
    o.Discount,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY o.Discount
ORDER BY o.Discount;


-- =========================================================
-- 14. PROFIT BY DISCOUNT
-- =========================================================

SELECT
    o.Discount,
    ROUND(
        SUM(
            (p.Unit_Price * o.Quantity * (1 - o.Discount))
            - (p.Cost * o.Quantity)
        ),
        2
    ) AS Profit
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY o.Discount
ORDER BY o.Discount;


-- =========================================================
-- 15. REVENUE BY COUNTRY
-- =========================================================

SELECT
    c.Country,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Customers_Staging c
    ON o.Customer_ID = c.Customer_ID
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY c.Country
ORDER BY Revenue DESC;


-- =========================================================
-- 16. ORDERS BY CATEGORY
-- =========================================================

SELECT
    p.Category,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Orders DESC;


-- =========================================================
-- 17. MONTHLY REVENUE BY YEAR
-- =========================================================

SELECT
    YEAR(o.Order_Date) AS Year,
    MONTH(o.Order_Date) AS Month,
    ROUND(
        SUM(p.Unit_Price * o.Quantity * (1 - o.Discount)),
        2
    ) AS Revenue
FROM Orders_Staging o
JOIN Products_Staging p
    ON o.Product_ID = p.Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    Year,
    Month;
