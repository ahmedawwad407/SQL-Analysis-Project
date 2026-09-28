-- SQL Project #3 - Marketing & Customer Analytics
-- 04_business_insights.sql
-- MySQL Workbench

USE marketing_analytics;

-- ============================================================
-- INSIGHT 1: Executive KPI summary
-- ============================================================
SELECT
    COUNT(DISTINCT o.Order_ID) total_orders,
    SUM(o.Quantity) units_sold,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Cost*o.Quantity),2) cost,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    ROUND(
        100*SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity)
        / NULLIF(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2
    ) profit_margin_pct
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID;

-- ============================================================
-- INSIGHT 2: Category revenue share
-- ============================================================
WITH category_sales AS (
    SELECT p.Category,
           SUM(p.Unit_Price*o.Quantity*(1-o.Discount)) revenue
    FROM Orders_Clean o
    JOIN Products_Clean p ON o.Product_ID=p.Product_ID
    GROUP BY p.Category
)
SELECT
    Category,
    ROUND(revenue,2) revenue,
    ROUND(100*revenue/SUM(revenue) OVER (),2) revenue_share_pct
FROM category_sales
ORDER BY revenue DESC;

-- ============================================================
-- INSIGHT 3: Product profitability
-- ============================================================
SELECT
    p.Product_ID,p.Product_Name,p.Category,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    ROUND(
        100*SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity)
        / NULLIF(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2
    ) margin_pct
FROM Orders_Clean o
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY p.Product_ID,p.Product_Name,p.Category
ORDER BY profit DESC
LIMIT 15;

-- ============================================================
-- INSIGHT 4: Customer segmentation
-- Segment is based on revenue relative to the average customer revenue.
-- ============================================================
WITH customer_value AS (
    SELECT
        c.Customer_ID,c.Customer_Name,c.Country,
        COALESCE(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0) revenue
    FROM Customers_Clean c
    LEFT JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
    LEFT JOIN Products_Clean p ON o.Product_ID=p.Product_ID
    GROUP BY c.Customer_ID,c.Customer_Name,c.Country
),
avg_value AS (
    SELECT AVG(revenue) avg_revenue FROM customer_value
)
SELECT
    cv.Customer_ID,cv.Customer_Name,cv.Country,
    ROUND(cv.revenue,2) revenue,
    CASE
        WHEN cv.revenue >= av.avg_revenue*2 THEN 'High Value'
        WHEN cv.revenue >= av.avg_revenue THEN 'Medium Value'
        ELSE 'Low Value'
    END customer_segment
FROM customer_value cv
CROSS JOIN avg_value av
ORDER BY cv.revenue DESC;

-- ============================================================
-- INSIGHT 5: Country sales and margin
-- ============================================================
SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) customers,
    COUNT(DISTINCT o.Order_ID) orders,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),2) revenue,
    ROUND(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity),2) profit,
    ROUND(
        100*SUM(p.Unit_Price*o.Quantity*(1-o.Discount)-p.Cost*o.Quantity)
        / NULLIF(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2
    ) margin_pct
FROM Customers_Clean c
JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
JOIN Products_Clean p ON o.Product_ID=p.Product_ID
GROUP BY c.Country
ORDER BY revenue DESC;

-- ============================================================
-- INSIGHT 6: Campaign efficiency
-- ============================================================
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

-- ============================================================
-- INSIGHT 7: Campaign type comparison
-- ============================================================
SELECT
    mc.Campaign_Type,
    COUNT(DISTINCT mc.Campaign_ID) campaigns,
    ROUND(SUM(mc.Budget),2) budget,
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

-- ============================================================
-- INSIGHT 8: Responders with purchase activity
-- ============================================================
SELECT
    c.Customer_ID,c.Customer_Name,c.Country,
    COUNT(DISTINCT cr.Response_ID) campaign_responses,
    COUNT(DISTINCT o.Order_ID) orders,
    ROUND(COALESCE(SUM(p.Unit_Price*o.Quantity*(1-o.Discount)),0),2) revenue
FROM Customers_Clean c
JOIN Campaign_Responses_Clean cr ON c.Customer_ID=cr.Customer_ID
LEFT JOIN Orders_Clean o ON c.Customer_ID=o.Customer_ID
LEFT JOIN Products_Clean p ON o.Product_ID=p.Product_ID
WHERE cr.Response='Responded'
GROUP BY c.Customer_ID,c.Customer_Name,c.Country
ORDER BY revenue DESC;

-- ============================================================
-- INSIGHT 9: Data-quality audit after cleaning
-- ============================================================
SELECT
    'Customers_Clean' table_name,
    COUNT(*) rows_count,
    SUM(Customer_ID IS NULL) null_primary_key
FROM Customers_Clean
UNION ALL
SELECT 'Products_Clean',COUNT(*),SUM(Product_ID IS NULL)
FROM Products_Clean
UNION ALL
SELECT 'Orders_Clean',COUNT(*),SUM(Order_ID IS NULL)
FROM Orders_Clean
UNION ALL
SELECT 'Marketing_Campaigns_Clean',COUNT(*),SUM(Campaign_ID IS NULL)
FROM Marketing_Campaigns_Clean
UNION ALL
SELECT 'Campaign_Responses_Clean',COUNT(*),SUM(Response_ID IS NULL)
FROM Campaign_Responses_Clean;

-- ============================================================
-- Portfolio questions answered by this file:
-- * What drives revenue and profit?
-- * Which categories/products generate the most sales?
-- * Which customer segments contribute the most revenue?
-- * How do countries differ in revenue and margin?
-- * Which campaign types generate responses?
-- * What is the campaign cost per responder?
-- * Do campaign responders also appear as purchasers?
-- ============================================================
