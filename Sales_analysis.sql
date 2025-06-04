---- DATABASE-----

CREATE Database Sales;

CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
            
Select * from retail_sales
LIMIT 10;

Select count(*) from retail_sales;

----

Select * from retail_sales
WHERE transaction_id IS NULL;

Select * from retail_sales
WHERE sale_date IS NULL;

Select * from retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
    Delete from retail_sales
    where SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL


----- Data cleaning

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
    DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?

SELECT count(*) as total_sale from retail_sales;

-- How many unique customers we have?

SELECT count(distinct customer_id) as total_count from retail_sales;

-- How many categories we have?

SELECT DISTINCT category as count_of_categories from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >=4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, sum(total_sale) as net_sale
from retail_sales
GROUP by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
    
   SELECT round(AVG(age),2) as average_age
   from retail_sales
   Where category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, count(*)
from retail_sales
Group By category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_avg_sales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY year, month
),
ranked_months AS (
    SELECT 
        year, 
        month, 
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM monthly_avg_sales
)
SELECT year, month, avg_sale
FROM ranked_months
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id, 
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, count(DISTINCT customer_id) as customer_count 
from retail_sales
GROUP By category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
