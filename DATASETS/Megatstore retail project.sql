-- Data Cleaning 


-- Create staging tables for each table


SELECT *
FROM customers;


CREATE TABLE customers_staging
LIKE customers;

SELECT *
FROM customers_staging;

INSERT customers_staging
SELECT *
FROM customers;

SELECT *
FROM products;

CREATE TABLE products_staging
LIKE products;

SELECT *
FROM products_staging;

INSERT products_staging
SELECT *
FROM products;


SELECT *
FROM sales;

CREATE TABLE sales_staging
LIKE sales;

SELECT *
FROM sales_staging;

INSERT sales_staging
SELECT *
FROM sales;

-- IDENTIFYING MISSING DATA IN EACH COLUMN

SELECT 
COUNT(*) AS total_rows,
SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS missing_customers,
SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS missing_products,
SUM(CASE WHEN Sales_Amount IS NULL THEN 1 ELSE 0 END) AS missing_sales
FROM sales_staging;

-- There are no missing values in the columns

-- CHECKING FOR DUPLICATES


SELECT Customer_ID, COUNT(*)
FROM customers_staging
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Product_ID, COUNT(*)
FROM products_staging
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT Sale_ID, COUNT(*)
FROM sales_staging
GROUP BY Sale_ID
HAVING COUNT(*) > 1;

-- no duplicates found 


-- CHECK FOR INCONSISTENT DATA

SELECT sales_staging.Product_ID
FROM sales_staging
LEFT JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
WHERE products_staging.Product_ID IS NULL;

-- all data is consistent 

-- REMOVE WHITE SPACES

SELECT Customer_Name, TRIM(Customer_Name)
FROM customers_staging;

Update customers_staging
SET Customer_Name = TRIM(Customer_Name);

SELECT Product_Name, TRIM(Product_Name)
FROM products_staging;

Update Products_staging
SET Product_Name = TRIM(Product_Name);

-- CAPITALIZE FIRST LETTER OR TEXT IN COLUMN

SELECT Product_Name,
CONCAT(UPPER(LEFT(Product_Name,1)), LOWER(SUBSTRING(Product_Name,2))) AS PRODUCT_NAME
FROM products_staging;

Update Products_staging
SET Product_Name = PRODUCT_NAME;

SELECT Product_Name
FROM products_staging;

-- CONVERT DATE TO A STANDARD FORMAT/CHANGING DATA TYPE OF A DATE COLUMN FROM TEXT TO DATE


SELECT `Date`
FROM sales_staging;


ALTER TABLE sales_staging 
MODIFY `Date` DATE;

-- HANDLE OUTLIERS
-- find price outliers in Products

SELECT *
FROM products_staging
WHERE Price > (SELECT AVG(Price) + 3 * STDDEV(Price) 
FROM products_staging);

-- No outliers

-- Create cleaned Tables 

CREATE TABLE Cleaned_Sales AS
SELECT *
FROM sales_staging
WHERE Product_ID IN (SELECT Product_ID FROM products_staging)
AND Customer_ID IN (SELECT Customer_ID FROM customers_staging);

SELECT *
FROM cleaned_sales;

-- EXPLORATORY DATA ANALYSIS 

-- TOTAL SALES BY REGION

SELECT Region, SUM(Sales_Amount) AS Total_Sales
FROM sales_staging
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY Region
ORDER BY 2 DESC;


-- High selling regions in DESC order ( South - 70153.8, North 67045.9, West 62478.0, East 57226.6)

SELECT Customer_ID, sum(Quantity) AS Total_Quantity
FROM sales_staging
GROUP BY Customer_ID
ORDER BY 2 DESC
LIMIT 5 ;

-- TOP Customer IDs with the highest quantiy of  purchases (ID98 - 98, ID45 - 84, ID29 - 84,  ID32 - 83, ID87 - 82)

WITH RankedCustomers AS 
(
SELECT Customer_ID, sum(Quantity) AS Total_Quantity,
RANK() OVER (ORDER BY SUM(Quantity) DESC) AS `Rank`
FROM sales_staging
GROUP BY Customer_ID
)
SELECT Customer_ID, Total_Quantity
FROM RankedCustomers
WHERE `Rank` = 1;


-- FIND customers with the most orders (Order count by sales id)

SELECT Customer_ID, COUNT(Sale_ID) AS Total_Purchases
FROM sales_staging
GROUP BY Customer_ID
ORDER BY 2 DESC
LIMIT 5 
;

-- (ID98 - 20 orders, ID59 - 16 ORDERS, ID29-16, 1D17-16, 1D20-15)


-- Find customers who spent the most money 

SELECT Customer_ID, SUM(Sales_Amount) AS Total_Spent
FROM sales_staging
GROUP BY Customer_ID
ORDER BY 2 DESC
LIMIT 5
;
-- Top 5 customers with Highest Spend (ID98 - 5873.8, ID59 - 4691.1, ID93 - 4090, ID25 -3939.1, ID26 3991)

WITH RankedCustomers AS 
(
SELECT Customer_ID, sum(Sales_Amount) AS Total_Spent,
RANK() OVER (ORDER BY SUM(Sales_Amount) DESC) AS `Rank`
FROM sales_staging
GROUP BY Customer_ID
)
SELECT Customer_ID, Total_Spent
FROM RankedCustomers
WHERE `Rank` = 1;

-- Top 5 selling Products by Sales Quantity 

SELECT Product_Name, COUNT(Sale_ID) as Total_Sales_Quantity
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Product_Name
ORDER BY 2 DESC
LIMIT 5;

SELECT
sales_staging.Product_ID, products_staging.Category,
SUM(sales_staging.Quantity) AS Quantity_sold
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY sales_staging.Product_ID, products_staging.Category
ORDER BY Quantity_sold DESC
LIMIT 5;

SELECT
sales_staging.Product_ID,
SUM(sales_staging.Quantity) AS Quantity_sold
FROM sales_staging
GROUP BY sales_staging.Product_ID
ORDER BY Quantity_sold DESC
LIMIT 5;

-- Top 5 selling products by sales quantity (P1 - 374, P3 - 318, P15 - 310, P5 - 297, P4 - 283)



-- Top 5 selling Products by Sales Amount

SELECT Product_Name, SUM(Sales_Amount) as Total_Sales
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Product_Name
ORDER BY 2 DESC
LIMIT 5;

-- Top 5 selling products by sales amount (P1 - 18460.9, P5 17045.4, P3 - 16070.9, P15 - 15536.4, P8 - 14058.8)

-- connect to POWER BI for visualization








-- NEW PRACTICE

-- MONTHLY
-- YEARLY 
-- BEST PERFORMING PRODUCTS AND CUSTOMER BY CATEGORY AND SEGMENT BASED ON ORDERS AND SALES 
-- CALCULATE PROFIT USING CTE
-- TIME SERIES

-- TOTAL REVENUE BY CATEGORY 
SELECT
ROUND(SUM(sales_staging.Sales_Amount)) AS Total_sales,
products_staging.Category
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Category
ORDER BY Total_Sales DESC;


-- TOTAL REVENUE BY SEGMENT

SELECT
ROUND(SUM(sales_staging.Sales_Amount)) AS Total_sales,
customers_staging.Segment
FROM sales_staging
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY segment
ORDER BY Total_Sales DESC;

SELECT *
FROM customers_staging c1
JOIN sales_staging s1
ON c1.Customer_ID = s1.Customer_ID
JOIN products_staging p1
on s1.Product_ID = p1.Product_ID 
;

SELECT customers_staging.Customer_Name, Round(SUM(Sales_Amount)) AS Total_Sales
FROM sales_staging 
JOIN  customers_staging  ON sales_staging.Customer_ID =customers_staging.Customer_ID
GROUP BY customers_staging.Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


-- Customer with the higest spent by segment 

WITH Ranked_Customers AS (
SELECT customers_staging.Customer_Name, 
customers_staging.Segment,
Round(SUM(Sales_Amount)) AS Total_Sales,
ROW_NUMBER () OVER (PARTITION BY customers_staging.Segment ORDER BY Round(SUM(Sales_Amount)) DESC) AS `Rank`
FROM sales_staging 
JOIN  customers_staging  ON sales_staging.Customer_ID =customers_staging.Customer_ID
GROUP BY customers_staging.Segment, customers_staging.Customer_Name
)
SELECT Segment, Customer_Name, Total_Sales
FROM Ranked_Customers
WHERE `Rank` =  1
;

-- highest spending customer by segment (corporate/c59/ 4691, Individual/c98/5874)

-- customers with highest spend in each category 

WITH Ranked_Customers AS (
SELECT products_staging.category,
customers_staging.Customer_Name,
ROUND(SUM(Sales_Amount)) AS Total_Spent,
ROW_NUMBER () OVER (PARTITION BY products_staging.Category ORDER BY ROUND(SUM(Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY products_staging.Category, customers_staging.Customer_Name
)
SELECT Category, Customer_Name, Total_Spent
FROM Ranked_Customers
WHERE `Rank` = 1
; 

-- Highest spending customer per category (Accessories/c8 = 2384, Clothing/C98 = 1234, Electronics/c87 = 2249, Furniture/c93 = 2482)


-- Customers with the highest order per category

WITH Ranked_Customers AS (
SELECT products_staging.Category,
customers_staging.Customer_Name,
COUNT(Sale_ID) AS Total_Orders,
ROW_NUMBER () OVER (PARTITION BY products_staging.Category ORDER BY COUNT(Sale_ID) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY products_staging.Category, customers_staging.Customer_Name
)
SELECT Category, Customer_Name, Total_orders
from Ranked_Customers
WHERE `Rank` = 1;


-- customer highest purchases per category (Accessories/c98 = 8, Clothing/C73 = 5, Electronics/c87 = 7, Furniture/c93 = 8)



-- Category with the highest total sales 


SELECT Products_staging.Category, ROUND(SUM(Sales_amount)) as Total_Sales
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY products_staging.Category
ORDER BY Total_sales DESC;

--  highest sales by category (Electronics - 90956, Accessories - 72085, Furniture - 59521, Clothing - 34344)

-- Product with the highest sales in each category

WITH Ranked_Products AS (
SELECT 
products_staging.Category, 
products_staging.Product_Name,
ROUND(SUM(Sales_amount)) as Total_Sales,
ROW_NUMBER () OVER (PARTITION BY products_staging.Category ORDER BY ROUND(SUM(Sales_amount)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY products_staging.Category, products_staging.Product_Name
)
SELECT Category, Product_Name, Total_Sales
FROM Ranked_Products
WHERE `Rank` = 1;

-- Highest selling product per category (Accesories/P1 = 18461, Clothing/p4 = 12786, Electronic/p3 = 16071, Furniture/p17 = 13796)


-- CALCULATE PROFIT PER PRODUCT USING CTE & WITHOUT CTE 

WITH Ranked_Profit AS (
SELECT
products_staging.Product_ID,
products_staging.Product_Name,
ROUND(SUM(sales_staging.Sales_amount)) AS Total_sales,
ROUND(SUM(sales_staging.Quantity * products_staging.Cost)) AS Total_cost,
ROUND(SUM(sales_staging.Sales_amount) - SUM(sales_staging.Quantity * products_staging.Cost)) AS profit
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY products_staging.Product_ID, products_staging.Product_Name
)
SELECT Product_ID, Product_Name, Profit
FROM Ranked_Profit
ORDER BY profit  DESC
LIMIT 5;

-- Top 5 most profitable products (ID5 - 14788, ID8 - 11645, ID4 - 10583, ID11 - 10060, ID13 - 9564)


SELECT
products_staging.Product_ID,
products_staging.Product_Name,
ROUND(SUM(sales_staging.Sales_amount)) AS Total_sales,
ROUND(SUM(sales_staging.Quantity * products_staging.Cost)) AS Total_cost,
ROUND(SUM(sales_staging.Sales_amount) - SUM(sales_staging.Quantity * products_staging.Cost)) AS profit
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY products_staging.Product_ID, products_staging.Product_Name
ORDER BY profit  DESC
LIMIT 5;


-- Profit per Category 


WITH Ranked_Profits AS (
SELECT 
products_staging.Product_ID,
products_staging.Product_Name,
products_staging.Category,
ROUND(SUM(sales_staging.Sales_amount)) AS Total_sales,
ROUND(SUM(sales_staging.Quantity * products_staging.Cost)) AS Total_cost,
ROUND(SUM(sales_staging.Sales_amount) - SUM(sales_staging.Quantity * products_staging.Cost)) AS profit
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY products_staging.Category, products_staging.Product_Name, products_staging.Product_ID
)
SELECT Product_ID, Product_Name, Category, Profit
FROM Ranked_Profits
ORDER BY profit DESC
LIMIT 5;

-- Top 5 most profitable products (ID5/Accessories - 14788, ID8/Accessories - 11645, ID4/Clothing - 10583, ID11/Clothing - 10060, ID13/Electronics - 9564)


-- Profit Per Segment

SELECT 
products_staging.Product_ID,
products_staging.Product_Name,
customers_staging.Segment,
SUM(sales_staging.Sales_Amount) AS total_sales,
SUM(products_staging.Cost * sales_staging.Quantity) AS Total_Cost,
SUM(sales_staging.Sales_Amount) - SUM(products_staging.Cost * sales_staging.Quantity) AS profit
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY Segment, Product_ID, Product_Name
ORDER BY profit DESC;


WITH Ranked_Profits AS (
SELECT 
products_staging.Product_ID,
products_staging.Product_Name,
customers_staging.Segment,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_sales,
ROUND(SUM(products_staging.Cost * sales_staging.Quantity)) AS Total_Cost,
ROUND(SUM(sales_staging.Sales_Amount) - SUM(products_staging.Cost * sales_staging.Quantity)) AS profit,
ROW_NUMBER () OVER (PARTITION BY customers_staging.Segment ORDER BY ROUND(SUM(sales_staging.Sales_Amount) - SUM(products_staging.Cost * sales_staging.Quantity)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY Segment, Product_ID, Product_Name
)
SELECT Product_ID, Product_Name, Segment, Profit
FROM Ranked_Profits
WHERE `Rank` <= 1;

-- Most profitable product per segment (id5/individual = 8735, id8/corporate = 6500)


-- NEW PRATICE


-- Most ordered product in each region 

SELECT 
products_staging.Product_Name,
sales_staging.Region,
ROUND(SUM(sales_staging.Quantity)) AS Total_quantity
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Product_Name, Region
ORDER BY Total_quantity DESC
;

WITH Ranked_Regions AS 
(
SELECT
products_staging.Product_Name,
sales_staging.Region,
ROUND(SUM(sales_staging.Quantity)) AS Total_quantity,
ROW_NUMBER () OVER (PARTITION BY Region ORDER BY ROUND(SUM(sales_staging.Quantity)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Product_Name, Region
)
SELECT
Product_Name, Region, Total_Quantity
FROM Ranked_Regions
WHERE `Rank` = 1;

-- Highest ordered product per region (East - p15 =104, North - p15 = 104, South - p1 = 131, West - p7 = 99)


-- Product with the highest sales in each segment & category

WITH Ranked_Segments AS (
SELECT
customers_staging.Segment,
products_staging.Product_Name,
products_staging.Category,
ROUND(SUM(sales_staging.Quantity)) AS Total_quantity,
ROW_NUMBER () OVER (PARTITION BY customers_staging.Segment ORDER BY ROUND(SUM(sales_staging.Quantity)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY Segment, Category, Product_Name
)
SELECT
Segment, Category, Product_Name, Total_quantity
FROM Ranked_Segments
WHERE `Rank` = 1;

-- By Quanity (Corporate/accessories/p1 = 202, indiividual/accessories/p1 = 172)

WITH Ranked_Segments AS (
SELECT
customers_staging.Segment,
products_staging.Product_Name,
products_staging.Category,
ROUND(SUM(sales_staging.Sales_Amount)) AS Total_Sales,
ROW_NUMBER () OVER (PARTITION BY customers_staging.segment ORDER BY ROUND(SUM(sales_staging.Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
JOIN customers_staging ON sales_staging.Customer_ID = customers_staging.Customer_ID
GROUP BY Segment, Category, Product_Name
)
SELECT 
Segment, Category, Product_Name, Total_sales
FROM Ranked_Segments
WHERE `Rank` = 1;

-- By Revenue (Corporate/Electronics/p15 = 9897, individual/accessories/p5 = 9997)

-- TIME SERIES

-- Sales Trend by Year

SELECT
`date`
FROM sales_staging;


SELECT
YEAR(sales_staging.`Date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) Total_Revenue
FROM sales_staging
GROUP BY sales_staging.`Date`
ORDER BY Sales_Year;


-- Top 5 highest sales by year 


WITH Ranked_Year AS 
(
SELECT
YEAR (Sales_staging.`Date`) As Sales_Year,
ROUND(SUM(Sales_staging.Sales_Amount)) AS Total_Revenue,
DENSE_RANK () OVER (PARTITION BY YEAR (Sales_staging.`Date`) ORDER BY ROUND(SUM(Sales_staging.Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
GROUP BY sales_staging.`date`
)
SELECT
Sales_year, Total_Revenue, `Rank`
FROM Ranked_Year
WHERE `Rank` <= 5;

WITH Ranked_Year AS 
(
SELECT
YEAR (Sales_staging.`Date`) As Sales_Year,
ROUND(SUM(Sales_staging.Sales_Amount)) AS Total_Revenue,
ROW_NUMBER () OVER (PARTITION BY YEAR (Sales_staging.`Date`) ORDER BY ROUND(SUM(Sales_staging.Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
GROUP BY sales_staging.`date`
)
SELECT
Sales_year, Total_Revenue, `Rank`
FROM Ranked_Year
WHERE `Rank` <= 5;


-- Sales Trend by Month

SELECT
MONTH (sales_staging.`Date`) AS sales_month,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_Revenue,
DENSE_RANK () OVER (PARTITION BY MONTH (sales_staging.`Date`) ORDER BY ROUND(SUM(sales_staging.Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
GROUP BY sales_staging.`Date`
ORDER BY sales_month;

WITH Ranked_Months AS 
(
SELECT
MONTH (sales_staging.`Date`) AS sales_month,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_Revenue,
DENSE_RANK () OVER (PARTITION BY MONTH (sales_staging.`Date`) ORDER BY ROUND(SUM(sales_staging.Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
GROUP BY sales_staging.`Date`
)
SELECT
Sales_Month, total_revenue, `Rank`
FROM Ranked_Months
WHERE `Rank` <= 5;


-- SALES TREND BY YEAR

-- HIGHEST SELLING PRODUCT IN EACH CATEGORY PER YEAR 

WITH Ranked_Years AS 
(
SELECT
YEAR(sales_staging.`date`) As Sales_Year,
products_staging.Category,
ROUND(SUM(sales_staging.Sales_Amount)) AS Total_Revenue,
DENSE_RANK () OVER (PARTITION BY YEAR(sales_staging.`date`), products_staging.Category ORDER BY ROUND(SUM(sales_staging.Sales_Amount))DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY YEAR(sales_staging.`date`), products_staging.Category
)
SELECT *
FROM Ranked_Years
Where `Rank` <= 5;


WITH Ranked_Years AS 
(
SELECT
YEAR(sales_staging.`date`) As Sales_Year,
products_staging.Category,
ROUND(SUM(sales_staging.Sales_Amount)) AS Total_Revenue,
DENSE_RANK () OVER (PARTITION BY YEAR(sales_staging.`date`) ORDER BY ROUND(SUM(sales_staging.Sales_Amount))DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY YEAR(sales_staging.`date`), products_staging.Category
)
SELECT *
FROM Ranked_Years
Where `Rank` <= 5;


-- SALES PER YEAR 

SELECT
products_staging.Product_ID,
YEAR(sales_staging.`date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_revenue
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY sales_staging.`date`, products_staging.Product_ID
ORDER BY total_revenue DESC
;

SELECT
YEAR(sales_staging.`Date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) Total_Revenue
FROM sales_staging
GROUP BY sales_staging.`Date`
ORDER BY Sales_Year;

-- YEAR OVER YEAR GROWTH

-- LAG gets the previous years revenue for comparison

SELECT
YEAR(sales_staging.`date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_revenue,
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)) AS P_year_Revenue,
ROUND(((ROUND(SUM(sales_staging.Sales_Amount))) - 
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)))/
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)) * 100) AS YoY_Growth
FROM sales_staging
GROUP BY YEAR(sales_staging.`date`)
ORDER BY Sales_Year;


WITH Lag_years AS 
(
SELECT
YEAR(sales_staging.`date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) AS total_revenue,
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)) AS P_year_Revenue,
ROUND(((ROUND(SUM(sales_staging.Sales_Amount))) - 
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)))/
LAG(ROUND(SUM(sales_staging.Sales_Amount))) OVER (ORDER BY YEAR(sales_staging.`date`)) * 100) AS YoY_Growth
FROM sales_staging
GROUP BY YEAR(sales_staging.`date`)
)
SELECT Sales_Year, total_revenue, YoY_Growth
FROM LAG_YEARS;

-- Year on Year Growth (2024 YoY = null, 2025 YoY = 4%, 2026 YOY = -26%)


-- ROLLING TOTAL REVENUE

SELECT
(sales_staging.`Date`),
sales_staging.Sales_Amount,
ROUND(SUM(sales_staging.Sales_Amount) OVER (ORDER BY sales_staging.`Date`)) AS Rolling_Revenue
FROM sales_staging
ORDER BY sales_staging.`Date`
;


WITH ranked_year AS
(
SELECT
YEAR(sales_staging.`Date`) AS `year`,
sales_staging.Sales_Amount,
ROUND(SUM(sales_staging.Sales_Amount) OVER (ORDER BY sales_staging.`Date`)) AS Rolling_Revenue
FROM sales_staging
ORDER BY sales_staging.`Date`
)
SELECT
`year`, Sales_Amount, rolling_revenue
FROM ranked_year
;




-- 	ROLLING TOTAL REVENUE PER YEAR

SELECT 
YEAR(sales_staging.`date`) AS sales_year,
sales_staging.`Date`,
ROUND(SUM(sales_staging.Sales_Amount) OVER (PARTITION BY YEAR(sales_staging.`date`) ORDER BY YEAR(sales_staging.`date`))) AS Total_Rolling_Revenue
FROM sales_staging
ORDER BY Sales_Year, sales_staging.`Date`;



WITH Rolling_Total As
(
SELECT 
YEAR(sales_staging.`date`) AS sales_year,
sales_staging.Sales_Amount,
ROUND(SUM(sales_staging.Sales_Amount) OVER (PARTITION BY YEAR(sales_staging.`date`) ORDER BY YEAR(sales_staging.`date`))) AS Total_Rolling_Revenue
FROM sales_staging
)
SELECT sales_year, Sales_Amount, Total_Rolling_Revenue
FROM Rolling_total;

WITH Rolling_Total As
(
SELECT 
YEAR(sales_staging.`date`) AS sales_year,
sales_staging.Sales_Amount,
ROUND(SUM(sales_staging.Sales_Amount) OVER (ORDER BY YEAR(sales_staging.`date`))) AS Total_Rolling_Revenue
FROM sales_staging
)
SELECT sales_year, Total_Rolling_Revenue
FROM Rolling_total;

-- Random Practice


SELECT
Product_Name,
ROUND(SUM(Sales_Amount)) AS Total_Sales
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY  Product_Name
ORDER BY Total_Sales DESC
LIMIT 5;


WITH Ranked_years AS 
(
SELECT 
Product_Name,
YEAR(sales_staging.`date`) AS sales_year,
ROUND(SUM(Sales_Amount)) AS Total_Sales,
ROW_NUMBER () OVER (PARTITION BY Product_Name, YEAR(sales_staging.`date`) ORDER BY ROUND(SUM(Sales_Amount)) DESC) AS `Rank`
FROM sales_staging
JOIN products_staging ON sales_staging.Product_ID = products_staging.Product_ID
GROUP BY Product_name, sales_staging.`date`
)
SELECT
Product_Name, Sales_year, Total_sales, `Rank`
FROM Ranked_years
WHERE `Rank` <= 3
;

SELECT
YEAR(sales_staging.`Date`) AS Sales_Year,
ROUND(SUM(sales_staging.Sales_Amount)) Total_Revenue
FROM sales_staging
GROUP BY sales_staging.`Date`
ORDER BY Total_Revenue DESC;





