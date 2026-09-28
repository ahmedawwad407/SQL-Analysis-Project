-- SQL Project #3 - Marketing & Customer Analytics
-- 03_data_analysis.sql
-- MySQL Workbench

USE marketing_analytics;

-- ============================================================
-- 1. Overall Sales KPIs
-- Revenue = Price * Quantity * (1 - Discount)
-- Profit = Revenue - Cost * Quantity
-- ============================================================
SELECT
    COUNT(DISTINCT o.Order_ID) total_orders,
    SUM(o.Quantity) units_sold,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Cost*o.Quantity),2) total_cost,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    ROUND(
        100*SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity)
        / NULLIF(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2
    ) profit_margin_pct
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID;

-- 2. Monthly sales trend
SELECT
    YEAR(o.Order_Date) order_year,
    MONTH(o.Order_Date) order_month,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    COUNT(DISTINCT o.Order_ID) orders
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
WHERE o.Order_Date IS NOT NULL
GROUP BY YEAR(o.Order_Date),MONTH(o.Order_Date)
ORDER BY order_year,order_month;

-- 3. Category performance
SELECT
    p.Category,
    COUNT(DISTINCT o.Order_ID) orders,
    SUM(o.Quantity) units_sold,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    ROUND(
        100*SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity)
        / NULLIF(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2
    ) margin_pct
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY p.Category
ORDER BY revenue DESC;

-- 4. Top 10 products by revenue
SELECT
    p.Product_ID,p.Product_Name,p.Category,
    SUM(o.Quantity) units_sold,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY p.Product_ID,p.Product_Name,p.Category
ORDER BY revenue DESC
LIMIT 10;

-- 5. Top 20 customers by revenue
SELECT
    c.Customer_ID,c.Customer_Name,c.Country,
    COUNT(DISTINCT o.Order_ID) orders,
    SUM(o.Quantity) units,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit
FROM Customers_Clean c
JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY c.Customer_ID,c.Customer_Name,c.Country
ORDER BY revenue DESC
LIMIT 20;

-- 6. Country performance
SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) customers,
    COUNT(DISTINCT o.Order_ID) orders,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit
FROM Customers_Clean c
JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY c.Country
ORDER BY revenue DESC;

-- 7. Discount analysis
SELECT
    ROUND(o.Discount*100,0) discount_pct,
    COUNT(*) order_lines,
    SUM(o.Quantity) units,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY o.Discount
ORDER BY o.Discount;

-- 8. Campaign performance
SELECT
    mc.Campaign_ID,mc.Campaign_Name,mc.Campaign_Type,
    ROUND(mc.Budget,2) budget,
    COUNT(DISTINCT cr.Response_ID) responses,
    COUNT(DISTINCT CASE WHEN cr.Response='Responded'
                        THEN cr.Customer_ID END) responders,
    ROUND(
        100*COUNT(DISTINCT CASE WHEN cr.Response='Responded'
                                THEN cr.Customer_ID END)
        / NULLIF(COUNT(DISTINCT cr.Response_ID),0),2
    ) response_rate_pct,
    ROUND(
        mc.Budget/NULLIF(
            COUNT(DISTINCT CASE WHEN cr.Response='Responded'
                                THEN cr.Customer_ID END),0
        ),2
    ) cost_per_responder
FROM Marketing_Campaigns_Clean mc
LEFT JOIN Campaign_Responses_Clean cr
ON mc.Campaign_ID=cr.Campaign_ID
GROUP BY mc.Campaign_ID,mc.Campaign_Name,mc.Campaign_Type,mc.Budget
ORDER BY response_rate_pct DESC;

-- 9. Campaign type performance
SELECT
    mc.Campaign_Type,
    COUNT(DISTINCT mc.Campaign_ID) campaigns,
    ROUND(SUM(mc.Budget),2) total_budget,
    COUNT(DISTINCT cr.Response_ID) responses,
    COUNT(DISTINCT CASE WHEN cr.Response='Responded'
                        THEN cr.Customer_ID END) responders,
    ROUND(
        100*COUNT(DISTINCT CASE WHEN cr.Response='Responded'
                                THEN cr.Customer_ID END)
        / NULLIF(COUNT(DISTINCT cr.Response_ID),0),2
    ) response_rate_pct
FROM Marketing_Campaigns_Clean mc
LEFT JOIN Campaign_Responses_Clean cr
ON mc.Campaign_ID=cr.Campaign_ID
GROUP BY mc.Campaign_Type
ORDER BY response_rate_pct DESC;

-- 10. Campaign responders and purchase activity
SELECT
    c.Customer_ID,c.Customer_Name,c.Country,
    COUNT(DISTINCT cr.Response_ID) campaign_responses,
    COUNT(DISTINCT o.Order_ID) orders,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue
FROM Customers_Clean c
JOIN Campaign_Responses_Clean cr ON c.Customer_ID=cr.Customer_ID
LEFT JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
LEFT JOIN Products_Clean p ON o.Product_ID=p.Product_ID
WHERE cr.Response='Responded'
GROUP BY c.Customer_ID,c.Customer_Name,c.Country
ORDER BY revenue DESC;
