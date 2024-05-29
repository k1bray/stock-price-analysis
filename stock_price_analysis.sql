USE stock_price_analysis;

EXEC sp_rename 'netflix_stock_price', 'nflx';               -- executed

-- DATA PROFILING & CLEANING

-- Initial Data Exploration and Profiling
-- Taking a look at the nflx table
SELECT * FROM nflx;

-- Taking a look at the spy table
SELECT * FROM spy
WHERE [Date] > '2002-05-22';        -- limiting time period to match NFLX data

-- Seeing if there are any rows where the Close price is different from the Adj Close price
SELECT * FROM nflx WHERE [Close] != [Adj Close];        -- 0 rows

-- Seeing a list of all tables in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Checking the schema of the nflx table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'nflx';

-- Deleting Adj Close column from nflx because it always equals the Close column
ALTER TABLE nflx DROP COLUMN [Adj Close];       -- Executed

-- Altering datatypes in nflx table - All were varchar(50) from import
ALTER TABLE nflx ALTER COLUMN [Date] DATE NOT NULL;
ALTER TABLE nflx ALTER COLUMN [Open] REAL NOT NULL;
ALTER TABLE nflx ALTER COLUMN [High] REAL NOT NULL;
ALTER TABLE nflx ALTER COLUMN [Low] REAL NOT NULL;
ALTER TABLE nflx ALTER COLUMN [Close] REAL NOT NULL;
ALTER TABLE nflx ALTER COLUMN [Volume] REAL NOT NULL;

-- Checking the schema of the spy table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'spy';

-- Alter SPY table [Date] column to DATE datatype for standardization with nflx table
ALTER TABLE spy ALTER COLUMN [Date] DATE NOT NULL;      -- Executed

-- Descriptive statistics for nflx table
SELECT
    COUNT(*) AS total_rows,
    MIN([Date]) AS min_date,
    MAX([Date]) AS max_date,
    MIN([Close]) AS min_close,
    MAX([Close]) AS max_close,
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume
FROM nflx
WHERE [Date] <= '2024-04-30';       -- limiting time period to match SPY data

-- Descriptive statistics for spy table
SELECT
    COUNT(*) AS total_rows,
    MIN(CAST([Date] AS DATE)) AS min_date,
    MAX(CAST([Date] AS DATE)) AS max_date,
    MIN([Close]) AS min_close,
    MAX([Close]) AS max_close,
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume
FROM spy
WHERE [Date] > '2002-05-22' ;       -- limiting time period to match NFLX data

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

-- Checking for and removing duplicate records in nflx table
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM nflx
)
DELETE FROM CTE WHERE row_num > 1;

-- Checking for and removing duplicate records in spy table
WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY Date ORDER BY Date) AS row_num
    FROM spy
    )
DELETE FROM CTE WHERE row_num > 1;


-- Exploratory Data Analysis (EDA)
-- Summary Statistics nflx table
SELECT 
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 140.53
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 140.56
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 700.99
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 0.35
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 15694382
FROM nflx;

-- Summary Statistics spy table
SELECT
    ROUND(AVG(CAST([Open] AS FLOAT)), 2) AS Avg_Open,           -- 182.92
    ROUND(AVG(CAST([Close] AS FLOAT)), 2) AS Avg_Close,         -- 182.04
    ROUND(MAX(CAST([High] AS FLOAT)), 2) AS Max_High,           -- 524.61
    ROUND(MIN(CAST([Low] AS FLOAT)), 2) AS Min_Low,             -- 50.26
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS Avg_Volume        -- 118013366
FROM spy
WHERE [Date] > '2002-05-22'     -- limiting time period to match NFLX data

-- Moving averages for nflx table
SELECT
    [Date],
    ROUND([Close], 2) AS [close],
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_30,
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_50,
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_200
FROM nflx
WHERE [Date] <= '2024-04-30';       -- limiting time period to match SPY data;

-- Moving average for spy table
SELECT
    [Date],
    ROUND([Close], 2) AS [close],
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_30,
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_50,
    ROUND(AVG(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW), 2) AS Moving_Avg_200
FROM spy
WHERE [Date] > '2002-05-22';        -- limiting time period to match NFLX data;

-- Historical volatility analysis for nflx table
SELECT 
    [Date], 
    ROUND([Close], 2) AS [close],
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30
FROM nflx
WHERE [Date] <= '2024-04-30';       -- limiting time period to match SPY data;

-- Historical volatility analysis for spy table
SELECT 
    CAST([Date] AS DATE) AS DateFormatted,
    ROUND([Close], 2) AS [close],
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30
FROM spy
WHERE [Date] > '2002-05-22';        -- limiting time period to match NFLX data;

-- Comparative Analysis
-- Compare Netflix’s performance with SPY over the same period

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




-- Calculating the yearly return for each underlying
-- *********A point to note is that the returns for 2002 and 2024 are only based on a partial year

-- NFLX annual returns since 2002
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,       -- year
            MIN([Date]) AS StartDate,   -- earliest trading day in the year
            MAX([Date]) AS EndDate      -- latest trading day in the year
        FROM
            nflx
        WHERE 
            [Date] <= '2024-04-30'      -- limited to match spy table
        GROUP BY
        YEAR([Date])
    ),
    StartEndPrices AS
    (
        SELECT
            yp.Year,                                                    -- year
            CAST(nflx_start.[Close] AS DECIMAL(18, 2)) AS StartPrice,   -- earliest closing price for the year
            CAST(nflx_end.[Close] AS DECIMAL(18, 2)) AS EndPrice        -- latest closing proce of the year
        FROM
            YearlyPrices yp
            JOIN nflx  AS nflx_start
                ON yp.StartDate = nflx_start.[Date]
            JOIN nflx AS nflx_end
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


--SPY annual returns since 2002
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,
            MIN([Date]) AS StartDate,
            MAX([Date]) AS EndDate
        FROM
            spy
        WHERE [Date] > '2002-05-22'         --limited to match nflx table
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

-- Calculate the current value of a $100 investment in NFLX on 2002-05-23
SELECT
    ROUND((100 / first_price.[Close]) * last_price.[Close], 2) AS investment_value,      -- $54056.70
    ROUND(((100 / first_price.[Close]) * last_price.[Close] - 100) / 100 * 100, 1) AS percent_return
FROM
    (
        SELECT TOP 1
            [Close]
        FROM nflx
        WHERE [Date] = '2002-05-23'
        ORDER BY [date] ASC
    ) AS first_price,
    (
        SELECT TOP 1
            [Close]
        FROM nflx
        ORDER BY [Date] DESC
    ) AS last_price;

-- Calculate the current value of a $100 investment in SPY on 2002-05-23
SELECT
    ROUND((100 / first_price.[Close]) * last_price.[Close], 2) AS investment_value,      -- $690.30
    ROUND(((100 / first_price.[Close]) * last_price.[Close] - 100) / 100 * 100, 1) AS percent_return
FROM
    (
        SELECT TOP 1
            [Close]
        FROM spy
        WHERE [Date] = '2002-05-23'
        ORDER BY [date] ASC
    ) AS first_price,
    (
        SELECT TOP 1
            [Close]
        FROM spy
        ORDER BY [Date] DESC
    ) AS last_price;