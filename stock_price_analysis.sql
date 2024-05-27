USE stock_price_analysis;

SELECT * FROM netflix_stock_price;
SELECT * FROM all_stocks_5yr;
SELECT * FROM SPX;
SELECT * FROM spy;


/*
Data Import and Cleaning
First, ensure your data is clean and ready for analysis in SQL Server. You can perform various cleaning operations using SQL queries.
*/

-- Check for Missing Values

SELECT *                                        -- 0 rows
FROM netflix_stock_price
WHERE 
    [Date] IS NULL 
    OR [Open] IS NULL 
    OR [High] IS NULL 
    OR [Low] IS NULL 
    OR [Close] IS NULL 
    OR [Volume] IS NULL;

SELECT                                          -- 0 rows         
    CAST([Date] AS DATE) AS DateFormatted,
    [Open],
    [High],
    [Low],
    [Close],
    [Adj Close],
    [Volume] 
FROM SPX
WHERE   
    [Date] IS NULL
    OR [Open] IS NULL
    OR [High] IS NULL
    OR [Low] IS NULL
    OR [Close] IS NULL
    OR [Adj Close] IS NULL
    OR [Volume] IS NULL;

SELECT                                          -- 0 rows         
    CAST([Date] AS DATE) AS DateFormatted,
    [Open],
    [High],
    [Low],
    [Close],
    [Volume]
FROM spy
WHERE   
    [Date] IS NULL
    OR [Open] IS NULL
    OR [High] IS NULL
    OR [Low] IS NULL
    OR [Close] IS NULL
    OR [Volume] IS NULL;

-- Remove Duplicate Records
-- 0 rows in all tables

WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM netflix_stock_price
)
DELETE FROM CTE WHERE row_num > 1;


WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM SPX
)
DELETE FROM CTE WHERE row_num > 1;


WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM spy
    )
DELETE FROM CTE WHERE row_num > 1;

/*
Exploratory Data Analysis (EDA) Using SQL
Perform initial analysis using SQL queries.
*/

--Summary Statistics

SELECT 
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 140.53
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 140.56
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 700.99
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 0.35
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 15694382
FROM netflix_stock_price;


SELECT
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 1684.76
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 1685.03
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 3588.11
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 666.79
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 3425394710
FROM SPX
WHERE [Date] > '2002-05-22'     -- limiting time period to match NFLX data
;


SELECT
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 182.92
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 182.04
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 524.61
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 50.26
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 118013366
FROM spy
WHERE [Date] > '2002-05-22'     -- limiting time period to match NFLX data

-- Time Series Analysis

SELECT 
    [Date], 
    ROUND([Close], 2) AS [close] 
FROM netflix_stock_price
ORDER BY Date;

/*
Advanced Analysis Using SQL
Use SQL for more sophisticated analyses.
*/
-- Moving Averages

SELECT 
    [Date] AS 'date', 
    ROUND([Close], 2) AS 'close', 
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS 'moving_avg_30'
FROM netflix_stock_price;

-- Volatility Analysis

SELECT [Date], 
       ROUND([Close], 2) AS [close],
       STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30
FROM netflix_stock_price;

/*
Comparative Analysis
If you have data for other stocks or indices, you can compare Netflix’s performance.
*/
-- Join with Another Stock Data

SELECT n.Date, n.Close AS Netflix_Close, o.Close AS Other_Stock_Close
FROM netflix_stock_price n
JOIN other_stock_data o ON n.Date = o.Date;

/*
Data Export for Visualization
Export your analysis results to a CSV file for further visualization.
*/

-- Use SQL Server Management Studio to export results to CSV

/*
Visualization Using Excel or Power BI

Excel:
Import Data: Load your CSV files into Excel.
Create Charts:
Line charts for stock prices over time.
Moving averages and volatility charts.
Comparative line charts for multiple stocks.
*/

/*
Power BI:
Import Data: Load your CSV files into Power BI.
Create Dashboards:
Line charts for historical stock prices.
Moving average and volatility visualizations.
Comparative analysis visuals.
*/

/*
Example Workflow In SQL Server:
*/
-- Data Cleaning:


DELETE FROM netflix_stock_price WHERE [Date] IS NULL;

-- Calculating Moving Average:

SELECT 
    [Date], 
    ROUND([Close], 2) AS [close], 
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_30
FROM netflix_stock_price;

-- Export Data:

/*
Use SQL Server Management Studio (SSMS) to export query results to a CSV file.
*/
/*
In Excel:

Load Data:

Go to Data > Get External Data > From Text and load your CSV file.
Create Charts:

Select your data range.
Go to Insert > Charts > Line Chart.
In Power BI:

Load Data:

Click Home > Get Data > Text/CSV and load your CSV file.
Create Visualizations:

Use the Line Chart visualization for time series data.
Add slicers for interactive filtering.
Presentation
Compile your findings into a presentation format:
*/
/*
Report: Write a detailed report with insights and visualizations.
Dashboard: Create an interactive Power BI dashboard.
Presentation: Prepare a PowerPoint presentation summarizing your analysis.
*/
/*
By leveraging SQL for data processing and Excel or Power BI for visualization, you can create a comprehensive 
data analysis project showcasing your SQL skills and your ability to interpret and visualize data effectively.
*/