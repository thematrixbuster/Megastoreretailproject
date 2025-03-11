Sales, Product, and Customer Insights for Growth and Profitability


In this project, I leveraged SQL for data cleaning and exploratory data analytics to uncover key insights into sales performance, top-performing products, regions, product categories and segments. The following steps outline the process, focusing on identifying growth drivers and underperforming areas.


**Objectives**

This analysis addresses the following questions:
1)	What are the sales and profitability trends?
2)	How do sales vary across months, quarters, and years?
3)	Which customer segment brought in the most sales
4)	Which products are top sellers, and which underperform?
5)	Which region has the highest sales volume?


**Skills demonstrated**

•	Data cleaning and transformation using SQL
•	Data modelling and analysis with DAX (calculated columns and measures)
•	Time intelligence analysis
•	Data visualization using Power Bi


**Data Preparation and Cleaning**

The first step was to organize the dataset by creating new staging tables. This allowed for cleaning and analysis without altering the original data. During the data cleaning process, I:
•	Ensured there were no duplicate records to be removed, to guarantee data integrity.
•	Ensured there were no missing values to be handled in key columns like Customer ID, Product ID, and Sales Amount
•	The date column was assigned with the correct data type.


**Sales Performance Analysis**


To analyse sales performance, I focused on four key aspects: seasons, regions, products, and customer segments.
1)	**Overall Sales Performance**: Over the period of 2024–2026, the company sold 5,000 units of its products, generating £256,910 in revenue. 

2)	**Profitability**: The company achieved an impressive profit of £112,357, reflecting a profit margin of 43.73%. 

3)	**Seasonality Trends**:  In year 2024 and 2026, the third quarter (Q3) and the month of August consistently emerged as high-performing periods. In 2024, Q3 generated £91,370 in revenue, while August 2026 contributed £70,230. 

The year 2025 stood out as the strongest year, generating £95,310 in revenue, with March being the best-performing month.

4)	**Top Performing Regions**: The highest sales were generated by the following regions (ranked in descending order by total sales):
•	South: £70,153.80
•	North: £67,045.90
•	West: £62,478.00
•	East: £57,226.60

This identified South and North as key areas for focusing marketing efforts to sustain growth.

6)	**Top 5 Selling Products by Sales Quantity and Sales Amount**:

**By Sales Quantity**:
•	Product 1: 374 units
•	Product 3: 318 units
•	Product 15: 310 units
•	Product 5: 297 units
•	Product 4: 283 units

**By Revenue**:
•	Product 1: £18,460.90
•	Product 5: £17,045.40
•	Product 3: £16,070.90
•	Product 15: £15,536.40
•	Product 8: £14,058.80

The data revealed the best-selling products by both quantity and revenue, providing a clear direction for inventory optimization. Products 1 is the best performing product by sales quantity and revenue.

**Underperforming Products**: The bottom 5 products (Product 10, 18, 7, 11, and 14) recorded the lowest revenue.

7)	**Top 5 Performing Customers**:

**By Quantity Ordered**:
•	Customer ID 98: 98 units
•	Customer ID 45: 84 units
•	Customer ID 29: 84 units
•	Customer ID 32: 83 units
•	Customer ID 87: 82 units

**By Order Count**:
•	Customer ID 98: 20 orders
•	Customer ID 59: 16 orders
•	Customer ID 29: 16 orders
•	Customer ID 17: 16 orders
•	Customer ID 20: 15 orders

**By Revenue**:
•	Customer ID 98: £5,873.80
•	Customer ID 59: £4,691.10
•	Customer ID 93: £4,090
•	Customer ID 25: £3,939.10
•	Customer ID 26: £3,991

These insights allowed for segmentation of top customers for targeted loyalty programs. Customer 1D 98 is the highest value customer by quantity ordered (98), frequency of orders (20) and value of order £5,873.80

**Customer Segments and Profitability**

1.	**Customer Segment Performance**:
•	Corporate customers spent the most with (£145,001).
•	The highest spending category for corporate customers was Electronic. Product 15 generated the highest revenue (£9,897.3)
•	Individual customers spent (£111,904).
•	The highest spending category for individual customers was Electronics. Product 5 generated the highest revenue (£9,788).
2.	**Top 5 Profitable Products**:
•	Product ID 5: £14,788
•	Product ID 8: £11,645
•	Product ID 4: £10,583
•	Product ID11: £10,060
•	Product ID 13: £9,564

These products contributed significantly to profitability, pointing to key areas to focus on for high-margin sales. 

The least profitable products: Products (14, 12,9,3,1) recorded the lowest profits. This means even if Product 1 is the highest performing revenue wise (£18,461), it generates the least profit (£333.2). Product 5 and 8 bring in more profit for the business even if they bring in less revenue (£17,045.40 and £14,058.80)

**Geographic and Product Performance**
1.	**Sales by Region**:
o	Highest sales by region: South led in quantity sold, revenue and profit (1328 products sold, £70,153.81 revenue generated, and $32.3k profit made)
o	Lowest sales by region: East generated the lowest revenue, quantity sold and profit (1136 products sold, £57,266 revenue generated and £23.6k profit made|)
2.	**Category Performance**:
**Top Categories by Sales**:
	Electronics: £90,956
	Accessories: £72,085
	Furniture: £59,521
	Clothing: £34,344

This insight shows which categories bring in the most revenue and identify opportunities for growth in underperforming categories like Clothing.

**Interactive Dashboards and Visualizations**
To facilitate continuous tracking of sales performance and profitability, interactive dashboards were created in Power BI, visualizing key metrics such as:
•	Total sales by region.
•	Total sales by category.
•	Top-selling products by revenue and profit.
•	Customer segmentation and profitability.

**Business Value and Actionable Insights**
With these insights, stakeholders can:
1.	Capitalize on the strong performance of Q3 and August by increasing marketing efforts, launching promotions, or introducing new products during these periods.
2.	Target top-performing regions like South and North for continued growth while addressing declining areas.
3.	Optimize inventory by focusing on high-performing products such as Product 1 and Product 5 (Accessories)
4.	Implement targeted loyalty programs for high-value customers, particularly focusing on corporate customer segments.
5.	Leverage category trends to adjust product offerings and boost revenue in Electronics and Accessories, while revamping strategies for Clothing.

This data-driven approach enables the company to focus on the key drivers of profitability, identify areas for improvement, and make informed decisions that accelerate growth.
Conclusion

By implementing data cleaning, exploration, and visualization leveraging SQL and Power BI, this project transformed raw data into actionable insights for boosting sales, improving product performance, and targeting high-value customer segments effectively, enabling data-driven decisions that optimize operations and drive growth. Through ongoing analysis and interactive dashboards, the company can stay agile and responsive to market changes.
