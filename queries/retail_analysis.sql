-- ====================================
-- Section 1: Fix Data Issues (Duplicates, Discrepancies)
-- ====================================
-- Handle duplicates in the sales_transaction table
SELECT TransactionID, COUNT(TransactionID) AS duplicate_count
FROM sales_transaction 
GROUP BY TransactionID 
HAVING COUNT(TransactionID) > 1;

CREATE TABLE sales_details AS 
SELECT DISTINCT * 
FROM sales_transaction;

DROP TABLE sales_transaction;
RENAME TABLE sales_details TO sales_transaction;

-- Fix price discrepancies between sales_transaction and product_inventory
SELECT sl.TransactionID, sl.Price AS sales_price, pi.Price AS product_price
FROM sales_transaction sl
JOIN product_inventory pi ON sl.ProductID = pi.ProductID
WHERE sl.Price <> pi.Price;

UPDATE sales_transaction st
SET Price = (
    SELECT pi.Price 
    FROM product_inventory pi
    WHERE st.ProductID = pi.ProductID
)
WHERE EXISTS (
    SELECT 1 
    FROM product_inventory 
    WHERE st.ProductID = pi.ProductID AND st.Price <> pi.Price
);

-- ====================================
-- Section 2: Analytical Queries
-- ====================================
-- Summarize total sales and quantities per product
SELECT ProductID, SUM(QuantityPurchased) AS total_quantity, 
       ROUND(SUM(QuantityPurchased * Price), 2) AS total_sales
FROM sales_transaction
GROUP BY ProductID
ORDER BY total_sales DESC;

-- Count transactions per customer
SELECT CustomerID, COUNT(*) AS total_transactions
FROM sales_transaction
GROUP BY CustomerID
ORDER BY total_transactions DESC;

-- Evaluate product category performance
SELECT Category, SUM(st.QuantityPurchased) AS total_quantity, 
       ROUND(SUM(st.QuantityPurchased * st.Price), 2) AS total_sales
FROM sales_transaction st
JOIN product_inventory pi ON pi.ProductID = st.ProductID
GROUP BY Category
ORDER BY total_sales DESC;

-- ====================================
-- Section 3: Other Analytical Queries
-- ====================================
-- Top 10 products with the highest total sales revenue
SELECT ProductID, SUM(QuantityPurchased) AS quantity,
      ROUND(SUM(QuantityPurchased * Price), 2) AS revenue
FROM sales_transaction
GROUP BY ProductID
ORDER BY revenue DESC
LIMIT 10;

-- Count transactions per customer to understand purchase frequency
SELECT CustomerID, COUNT(*) AS total_transaction_customer
FROM sales_transaction
GROUP BY CustomerID
ORDER BY total_transaction_customer DESC;

-- Identify the sales trend (revenue pattern)
SELECT DATE_FORMAT(STR_TO_DATE(TransactionDate,'%d/%m/%y'),'%Y-%m-%d') AS trans_date,
COUNT(*) AS transaction_count, 
SUM(QuantityPurchased) AS total_quantity, ROUND(SUM(QuantityPurchased * Price),2) AS total_sales
FROM sales_transaction
GROUP BY trans_date
ORDER BY trans_date DESC;

-- Evaluate month-on-month sales growth rate
WITH helper_table AS (
    SELECT EXTRACT(MONTH FROM STR_TO_DATE(TransactionDate,'%d/%m/%y')) AS month,
           SUM(QuantityPurchased* PRICE) AS total_sales
    FROM sales_transaction
    GROUP BY EXTRACT(MONTH FROM STR_TO_DATE(TransactionDate,'%d/%m/%y'))
)
SELECT month, total_sales,
       LAG(total_Sales) OVER (ORDER BY month) AS previous_month_sales,
       ROUND(((LAG(total_Sales) OVER (ORDER BY month) - total_sales) / 
              LAG(total_Sales) OVER (ORDER BY month)) * 100, 2) AS mom_percentage_growth
FROM helper_table
ORDER BY month;
