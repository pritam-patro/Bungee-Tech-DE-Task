/* Question 1: Top 3 categories within every country based on total sales in the current year.
    The output should be in this format (Country, Category, Total sales) */

WITH RankedCategories AS (
    SELECT 
        COUNTRY, 
        DESCRIPTION AS Category, 
        SUM(CAST(REPLACE(PRICE, '$', '') AS FLOAT)) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY COUNTRY ORDER BY SUM(CAST(REPLACE(PRICE, '$', '') AS FLOAT)) DESC) AS rank
    FROM MAIN_DE
    GROUP BY COUNTRY, DESCRIPTION
)
SELECT COUNTRY, Category, Total_Sales
FROM RankedCategories
WHERE rank <= 3;

/*Question 2: Total sales of products sold in both Feb & Jan , Total sales of products sold ONLY in Jan, Total sales of products sold ONLY in Feb.
    Output should be in this format (jan_feb_sales, jan_sales, feb_sales)
*/

WITH Period1 AS (
    SELECT SKU, SUM(CAST(REPLACE(PRICE, '$', '') AS FLOAT)) AS Total_Sales
    FROM MAIN_DE
    WHERE YEAR = '1990'  -- Example condition for first period
    GROUP BY SKU
),
Period2 AS (
    SELECT SKU, SUM(CAST(REPLACE(PRICE, '$', '') AS FLOAT)) AS Total_Sales
    FROM MAIN_DE
    WHERE YEAR = '2000'  -- Example condition for second period
    GROUP BY SKU
)
SELECT 
    COALESCE(SUM(CASE WHEN Period1.SKU IS NOT NULL AND Period2.SKU IS NOT NULL THEN Period1.Total_Sales + Period2.Total_Sales END), 0) AS jan_feb_sales,
    COALESCE(SUM(CASE WHEN Period1.SKU IS NOT NULL AND Period2.SKU IS NULL THEN Period1.Total_Sales END), 0) AS jan_sales,
    COALESCE(SUM(CASE WHEN Period1.SKU IS NULL AND Period2.SKU IS NOT NULL THEN Period2.Total_Sales END), 0) AS feb_sales
FROM Period1
FULL OUTER JOIN Period2 ON Period1.SKU = Period2.SKU;


/*Question 3: In the query written in question #1 what are the partitions and indexes you would create for best performance?*/

Partitions: Partition by COUNTRY or YEAR for performance optimization in grouping and filtering operations.
Indexes: Create indexes on SKU, COUNTRY, and PRICE

CREATE INDEX idx_country ON MAIN_DE(COUNTRY);
CREATE INDEX idx_price ON MAIN_DE(PRICE);
CREATE INDEX idx_sku ON MAIN_DE(SKU);
