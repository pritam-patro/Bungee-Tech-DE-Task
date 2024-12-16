SELECT 
    COUNTRY, 
    DESCRIPTION AS Category, 
    SUM(CAST(REPLACE(PRICE, '$', '') AS FLOAT)) AS Total_Sales
FROM MAIN_DE
GROUP BY COUNTRY, DESCRIPTION
ORDER BY COUNTRY, Total_Sales DESC;