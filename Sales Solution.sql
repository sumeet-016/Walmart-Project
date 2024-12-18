CREATE DATABASE IF NOT EXISTS walmart_sales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- For selecting the complete table and showing the compete values in the table
SELECT * FROM sales;

-- ---------------------------------------------------------------------
-- -----------------time_of_date_---------------------------------------
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------
-- ------------------------Business Questions To Answer---------------------------------

-- -------------------------------------------------------------------------------------
-- ------------------------------Generic Question---------------------------------------
-- -------------------------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM sales;

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- ---------------------------------Product---------------------------------------------

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;

-- What is the most common payment method?
SELECT payment, COUNT(*) AS method_count
FROM sales
GROUP BY payment
ORDER BY method_count DESC
LIMIT 1;

-- Answer :- Cash.


-- What is the most selling product line?
SELECT product_line, COUNT(*) AS most_selling_product_line
FROM sales
GROUP BY product_line
ORDER BY most_selling_product_line
LIMIT 1;

-- Answer :- Health and beauty.


-- What is the total revenue by month?
SELECT month_name AS month,
SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue;


-- What month had the largest COGS?
SELECT month_name AS month,
SUM(COGS) AS cogs 
FROM sales
GROUP BY month
ORDER BY cogs DESC;

-- Answer :- January.


-- What product line had the largest revenue?
SELECT product_line, 
SUM(total) AS total_product_revenue
FROM sales
GROUP BY product_line
ORDER BY total_product_revenue DESC; 

-- Answer :- 56144.8440 (Food and beverages).


-- What is the city with the largest revenue?
SELECT city, branch,
SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC
LIMIT 1;

-- Answer :- 110490.7755 (Naypyitaw, Branch C).


-- What product line had the largest VAT(tax_pct)?
SELECT city,
AVG(tax_pct) AS avg_tax
FROM sales 
GROUP BY city
ORDER BY avg_tax DESC;

-- Answer :- Naypyitaw(Product line had the largest tax_pct).


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales?
SELECT product_line,
(CASE WHEN AVG(quantity) > 5.5 THEN "Good"
	ELSE "Bad" END) AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT branch, 
SUM(quantity) AS sum_of_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) AS avg_of_quantity
FROM sales)
ORDER BY sum_of_quantity DESC;

-- Answer :- Branch A (most sold products than average product sales).


-- What is the most common product line by gender?
SELECT gender,
COUNT(product_line) AS number_of_product_line
FROM sales
GROUP BY gender
ORDER BY number_of_product_line DESC;

-- Answer :- Male(498) and Females(497).


-- What is the average rating of each product line?
SELECT product_line,
AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating;

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------
-- -----------------------------------Sales---------------------------------------------

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday?
SELECT time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Answer :- Evening has the highest numbers of sales(58).


-- Which of the customer types brings the most revenue?
SELECT customer_type,
SUM(total) AS sum_of_total_revenue
FROM sales
GROUP BY customer_type
ORDER BY sum_of_total_revenue DESC
LIMIT 1;

-- Answer :- Members(163625.1015).


-- Which city has the largest tax percentage?
SELECT city,
SUM(tax_pct) AS total_sum_of_tax_percentage
FROM sales
GROUP BY city 
ORDER BY total_sum_of_tax_percentage DESC
LIMIT 1;

-- Answer :- Naypyitaw(5261.4655).


-- Which customer type pays the most in tax_percentage?
SELECT customer_type,
SUM(tax_pct) AS total_taxpct
FROM sales
GROUP BY customer_type
ORDER BY total_taxpct;

-- Answer :- Normal(7488.6330).

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- -----------------------------------Customer------------------------------------------

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type 
FROM sales;


-- How many unique payment methods does the data have?
SELECT DISTINCT payment 
FROM sales;


-- What is the most common customer type?
SELECT customer_type,
COUNT(*) AS total_count
FROM sales
GROUP BY customer_type
ORDER BY total_count DESC 
LIMIT 1;

-- Answer :_ Member(499).


-- Which customer type buys the most?
SELECT customer_type,
SUM(total) AS sum_of_total
FROM sales
GROUP BY customer_type
ORDER BY sum_of_total DESC;

-- Answer :- Member(163625.1015).


-- What is the gender of most of the customers?
SELECT gender,
COUNT(*) AS gender_count
FROM sales 
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1;

-- Answer :- Male(498).


-- What is the gender distribution per branch?
SELECT branch, gender,
COUNT(*) AS count
FROM sales 
GROUP BY branch, gender
ORDER BY branch, count DESC;


-- Which time of the day do customers give most ratings?
SELECT time_of_day,
AVG(rating) AS average_rating
FROM sales
GROUP BY time_of_day
ORDER BY average_rating DESC;

-- Answer :- Afternoon(7.02340).


-- Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day,
AVG(rating) AS average_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, average_rating DESC; 


-- Which day of the week has the best avg ratings?
SELECT day_name,
AVG(rating) AS average_rating
FROM sales
GROUP BY day_name 
ORDER BY average_rating DESC;

-- Answer :- Monday, friday and tuesday are the top 3 best average rating of the week.


-- Which day of the week has the best average ratings per branch?
SELECT day_name, branch,
AVG(rating) AS average_rating
FROM sales
GROUP BY day_name, branch
ORDER BY average_rating DESC;

-- Answer :- On friday(A), monday(B) and saturday(C) are the top 3 days of the week that
-- --------- have the best ratings per branch-------------------------------------------


-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------