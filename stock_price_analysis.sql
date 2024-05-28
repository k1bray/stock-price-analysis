USE stock_price_analysis;

EXEC sp_rename 'netflix_stock_price', 'nflx';               -- executed

-- DATA PROFILING

-- Initial Data Exploration
SELECT *
FROM nflx;

SELECT *
FROM spy
WHERE [Date] > '2002-05-22';                     -- limiting time period to match NFLX data

SELECT *
FROM INFORMATION_SCHEMA.TABLES;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'nflx';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'spy';

-- Descriptive Statistics
SELECT
    COUNT(*) AS total_rows,
    MIN([Date]) AS min_date,
    MAX([Date]) AS max_date,
    MIN([Close]) AS min_close,
    MAX([Close]) AS max_close,
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume
FROM nflx
WHERE [Date] <= '2024-04-30';                   -- limiting time period to match SPY data


SELECT
    COUNT(*) AS total_rows,
    MIN(CAST([Date] AS DATE)) AS min_date,
    MAX(CAST([Date] AS DATE)) AS max_date,
    MIN([Close]) AS min_close,
    MAX([Close]) AS max_close,
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume
FROM spy
WHERE [Date] > '2002-05-22' ;                     -- limiting time period to match NFLX data


/*
Data Import and Cleaning
First, ensure your data is clean and ready for analysis in SQL Server. You can perform various cleaning operations using SQL queries.
*/



-- Check for Missing Values

SELECT *                                        -- 0 rows
FROM nflx
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
-- 0 duplicate rows in all tables

WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM nflx
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
Perform initial analysis using SQL queries
*/

--Summary Statistics

SELECT 
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 140.53
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 140.56
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 700.99
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 0.35
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 15694382
FROM nflx;


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
FROM nflx
ORDER BY [Date];

/*
Advanced Analysis Using SQL
Use SQL for more sophisticated analyses
*/
-- Moving Averages

SELECT 
    [Date] AS 'date', 
    ROUND([Close], 2) AS 'close', 
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS 'moving_avg_30'
FROM nflx;


SELECT
    CAST([Date] AS DATE) AS DateFormatted,
    ROUND([Close], 2) AS 'close',
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS 'moving_avg_30'
FROM spy
WHERE [Date] > '2002-05-22'                         -- limiting time period to match NFLX data;

-- Volatility Analysis

SELECT 
    [Date], 
    ROUND([Close], 2) AS [close],
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30
FROM nflx;


SELECT 
    CAST([Date] AS DATE) AS DateFormatted,
    ROUND([Close], 2) AS [close],
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30
FROM spy;

/*
Comparative Analysis

Compare Netflix’s performance with SPY over the same period
*/
-- Join with SPY ETF Data

SELECT 
    n.[Date], 
    ROUND(n.[Close], 2) AS netflix_close, 
    ROUND(s.[Close], 2) AS spy_close
FROM 
    nflx n
    JOIN spy s 
        ON n.[Date] = s.[Date];

/*
Data Export for Visualization
Export your analysis results to a CSV file for further visualization
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

DELETE FROM nflx WHERE [Date] IS NULL;

DELETE FROM spy WHERE [Date] IS NULL;

-- Calculating Moving Average:

SELECT 
    [Date], 
    ROUND([Close], 2) AS [close], 
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_30
FROM nflx;

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



/*
Calculating the yearly return for each underlying

*********A point to note is that the return for 2002 is only based on a partial year
*/

--NFLX
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,
            MIN([Date]) AS StartDate,
            MAX([Date]) AS EndDate
        FROM
            nflx
        GROUP BY
        YEAR([Date])
    ),
    StartEndPrices
    AS
    (
        SELECT
            yp.Year,
            CAST(nflx_start.[Close] AS DECIMAL(18, 2)) AS StartPrice,
            CAST(nflx_end.[Close] AS DECIMAL(18, 2)) AS EndPrice
        FROM
            YearlyPrices yp
            JOIN
            nflx  AS nflx_start
                ON yp.StartDate = nflx_start.[Date]
            JOIN
            nflx AS nflx_end
                ON yp.EndDate = nflx_end.[Date]
    )
SELECT
    Year,
    StartPrice,
    EndPrice,
    RTRIM(CAST(ROUND((((EndPrice - StartPrice) / StartPrice) * 100), 1) AS DECIMAL(18, 1))) AS PercentReturn
FROM
    StartEndPrices
ORDER BY
    Year;


--SPY
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,
            MIN([Date]) AS StartDate,
            MAX([Date]) AS EndDate
        FROM
            spy
        WHERE [Date] > '2002-05-22'
        GROUP BY
        YEAR([Date])
    ),
    StartEndPrices
    AS
    (
        SELECT
            yp.Year,
            CAST(spy_start.[Close] AS DECIMAL(18, 2)) AS StartPrice,
            CAST(spy_end.[Close] AS DECIMAL(18, 2)) AS EndPrice
        FROM
            YearlyPrices yp
            JOIN
            spy  AS spy_start
                ON yp.StartDate = spy_start.[Date]
            JOIN
            spy AS spy_end
                ON yp.EndDate = spy_end.[Date]
    )
SELECT
    Year,
    StartPrice,
    EndPrice,
    RTRIM(CAST(ROUND((((EndPrice - StartPrice) / StartPrice) * 100), 1) AS DECIMAL(18, 1))) AS PercentReturn
FROM
    StartEndPrices
ORDER BY
    Year;



/*
What day of the week is NFLX/SPY most likely to be up?
*/

/*
What day of the week is NFLX/SPY most likely to have the highest volume?
*/

/*
Annual-Monthly trends up/down?
*/
















SELECT ABS(-243.5)                                  -- absolute value

SELECT ABS(100 / 1.2)                               -- absolute value

SELECT CAST(100 / 1.2 AS INT)                       -- INT can't have decimals, or remainders

SELECT FLOOR(100 / 1.2) AS WholeNumberResult;       -- this is the way




/*
Start date
Number of shares for $100
Cost basis per share (starting close price)
Cost basis for investment (starting close price * number of shares)

End date
Sale price per share (ending close price)
Sale price of investment (ending close price * number of shares)

Difference between sale price of investment and starting price of investment
*/

SELECT *
FROM nflx;

SELECT TOP 1
    [Date] AS start_date,                                                   -- 2002-05-23
    ROUND(CAST([Close] AS FLOAT), 2) AS start_per_share_cost_basis          -- 1.20
FROM nflx;

SELECT 
    FLOOR(100 / 
    (
        SELECT TOP 1
            ROUND(CAST([Close] AS FLOAT), 2) AS start_per_share_cost_basis
        FROM nflx
    )
    ) AS number_of_shares                                                   -- 83 shares
FROM nflx
;





























