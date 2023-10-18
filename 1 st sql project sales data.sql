Create database CustomerShop;

Use CustomerShop;


CREATE TABLE Sales (
    invoice_no VARCHAR(10),
    customer_id VARCHAR(10),
    gender VARCHAR(10),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price DECIMAL(10, 2),
    payment_method VARCHAR(20),
    Month_Name VARCHAR(15),
    Dateno INT,
    Years INT,
    shopping_mall VARCHAR(30),
    Total_Sales DECIMAL(10, 2)
);

select * from Sales;

--- Q1) Gender-wise distribution of Customer Shopping
select gender,count(gender) as total_customers
from sales
group by gender
order by total_customers desc;

----Q2) Product categorywise distribution of Customer Shopping
select category, count(customer_id) as Total_customer
from sales
group by category
order by Total_customer;

----Q3) Find the total sales for each shopping mall.

SELECT shopping_mall, SUM(Total_Sales) AS Total_Sales
FROM Sales
GROUP BY shopping_mall;


---Q4) Top 5 customer by total_Shopping_sales
select customer_id, sum(total_sales) as salesprice
from sales
group by customer_id
order by salesprice
 desc limit 5;
 
 
 ----Q5) Month-wise distribution of Shopping_sales 
 select month_name, sum(total_sales) as Total_Monthwise_sales
 from sales
 where years in(2021,2022,2023)
 group by month_name
 order by Total_Monthwise_sales
 
 select * from sales;
 
 ---Q6) Year-wise total Shopping Sales
 select years  ,sum(total_sales)as total_sales_price from
 sales
 group by years
 order by total_sales_price
 desc limit 5


---Q7) Popular Paymentmethod among customers for Shopping.

select payment_method,count(customer_id)as counts
from sales
group by payment_method
order by counts
desc 

---Q8)Average price per unit for each category in Shopping
select category,avg(price) as avg_price_per_unit
from sales
group by category
order by avg_price_per_unit

select * from sales;
---Q9) Categorywise purchase by male and female .

select category,
		SUM( CASE WHEN gender='Male' THEN 1 ELSE 0 END) AS Malecount,
		SUM( CASE WHEN gender= 'Female' THEN 1 ELSE 0 END) AS Femalecount
	FROM sales
	group by category;

--Q10) Find the month with the highest total Shopping sales for each year.
with MonthlySales AS(
	select Years,month_name,sum(total_sales) Monthly_total
	from sales
	group by Years,month_name
)
SELECT Years,Month_name,monthly_total
FROM(
	SELECT Years,month_name,monthly_total,
	RANK() over (partition by years order by monthly_total desc) as Rank
	FROM MonthlySales
)RankedSales
where rank = 1;

select * from sales;

---- Q11) Determine the month with the highest average purchase quantity.

select month_name, round(avg(quantity),0) as average_purchase_quantity
from sales
group by month_name
order by average_purchase_quantity;

select * from sales;

---Q12) Find the top 5 product categories that generated the most revenue in a each year. 

WITH RankedCategories AS (
    SELECT
        Years,
        category,
        SUM(Total_Sales) AS Total_Revenue,
        RANK() OVER (PARTITION BY Years ORDER BY SUM(Total_Sales) DESC) AS Rank
    FROM Sales
    GROUP BY Years, category
)
SELECT Years, category, Total_Revenue
FROM RankedCategories
WHERE Rank <= 5;



select * from sales

---Q13) Calculate the year-over-year growth rate in total sales for each shopping mall.

WITH SalesGrowth AS(
	SELECT shopping_mall,Years,
		(SUM(Total_Sales) - LAG(SUM(Total_sales),1,0) OVER(partition by shopping_mall order by years))/
		LAG(sum(Total_Sales),1,1) OVER (partition by shopping_mall order by Years) AS sales_growth
	from sales
	group by shopping_mall,years
	
)
select * from SalesGrowth


---Q14) Find the shopping mall with the highest overall sales, and for that mall,
--       identify the top 5 categories that contributed the most to its revenue.

WITH MallSales AS (
    SELECT shopping_mall, SUM(Total_Sales) AS Mall_Total_Sales
    FROM Sales
    GROUP BY shopping_mall
)
SELECT s.shopping_mall, s.category, SUM(s.Total_Sales) AS Category_Sales
FROM Sales s
JOIN MallSales m ON s.shopping_mall = m.shopping_mall
WHERE s.shopping_mall = (SELECT shopping_mall FROM MallSales ORDER BY Mall_Total_Sales DESC LIMIT 1)
GROUP BY s.shopping_mall, s.category
ORDER BY Category_Sales DESC
LIMIT 5;









