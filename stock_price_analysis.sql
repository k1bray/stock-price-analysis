USE stock_price_analysis;




-- DATA PROFILING & CLEANING
-- Initial Data Exploration and Profiling

-- Renaming 'netflix_stock_price' to 'nflx' for query simplification
EXEC sp_rename 'netflix_stock_price', 'nflx';               -- executed

-- Taking a look at the nflx table
SELECT * FROM nflx;

-- Checking time periods for nflx where the stick had been split
-- trying to see if the [Close] prices in the dataset have been split-adjusted
-- The price data seems to be split adjusted
-- 2002-05-23 IPO price for NFLX was $15.00 per share - Dataset shows earliest price at $1.156429
SELECT *
FROM nflx 
WHERE [Date] BETWEEN '2004-01-01' AND '2004-01-31'      -- 2-for-1 split

SELECT *
FROM nflx
WHERE [Date] BETWEEN '2015-06-01' AND '2015-06-30'      -- 7-for-1 split

-- Taking a look at the spy table
SELECT * FROM spy
WHERE [Date] > '2002-05-22';        -- limiting time period to match NFLX data

-- Seeing a list of all tables in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Checking the schema of the nflx table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'nflx';

-- Seeing if there are any rows where the Close price is different from the Adj Close price
SELECT * FROM nflx WHERE [Close] != [Adj Close];        -- 0 rows

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

--Dropping unused columns from the SPY table
ALTER TABLE spy DROP COLUMN [Day];          -- Executed
ALTER TABLE spy DROP COLUMN [Weekday];      -- Executed
ALTER TABLE spy DROP COLUMN [Week];         -- Executed
ALTER TABLE spy DROP COLUMN [Month];        -- Executed
ALTER TABLE spy DROP COLUMN [Year];         -- Executed

-- Descriptive statistics for nflx table
SELECT
    COUNT(*) AS total_rows,                                     -- 5522 total_rows
    MIN([Date]) AS min_date,                                    -- 2002-05-23 min_date
    MAX([Date]) AS max_date,                                    -- 2024-04-30 max_date
    MIN([Close]) AS min_close,                                  -- 0.372857 min_close
    MAX([Close]) AS max_close,                                  -- 691.69 max_close
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume    -- 15735357 avg volume
FROM nflx
WHERE [Date] <= '2024-04-30';       -- limiting time period to match SPY data

-- Descriptive statistics for spy table
SELECT
    COUNT(*) AS total_rows,                                     -- 5522 total_rows
    MIN(CAST([Date] AS DATE)) AS min_date,                      -- 2002-05-23 min_date
    MAX(CAST([Date] AS DATE)) AS max_date,                      -- 2024-04-30 max_date
    MIN([Close]) AS min_close,                                  -- 51.020744 min_close
    MAX([Close]) AS max_close,                                  -- 523.17 max_close
    ROUND(AVG(CAST([Volume] AS FLOAT)), 0) AS average_volume    -- 118013366 avg volume
FROM spy
WHERE [Date] > '2002-05-22' ;       -- limiting time period to match NFLX data

-- Check for Missing Values in the nflx table
SELECT *                                        -- 0 rows
FROM nflx
WHERE 
    [Date] IS NULL 
    OR [Open] IS NULL 
    OR [High] IS NULL 
    OR [Low] IS NULL 
    OR [Close] IS NULL 
    OR [Volume] IS NULL;

-- Check for Missing Values in the spy table
SELECT *                                         -- 0 rows         
FROM spy
WHERE   
    [Date] IS NULL
    OR [Open] IS NULL
    OR [High] IS NULL
    OR [Low] IS NULL
    OR [Close] IS NULL
    OR [Volume] IS NULL
    OR [Day] IS NULL
    OR [Weekday] IS NULL
    OR [Week] IS NULL
    OR [Month] IS NULL
    OR [Year] IS NULL;

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







-- EXPLORATORY DATA ANALYSIS (EDA)
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
    ROUND([Close], 2) AS nflx_close,
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS nflx_Volatility_30
FROM nflx
WHERE [Date] <= '2024-04-30';       -- limiting time period to match SPY data;

-- Historical volatility analysis for spy table
SELECT 
    [Date] AS [Date],
    ROUND([Close], 2) AS spy_close,
    STDEV(CAST([Close] AS FLOAT)) OVER(ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS spy_Volatility_30
FROM spy
WHERE [Date] > '2002-05-22';        -- limiting time period to match NFLX data;








-- COMPARATIVE ANALYSIS
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


-- Calculating the yearly return for each underlying
-- *********A point to note is that the returns for 2002 and 2024 are only based on a partial year

-- NFLX annual returns since 2002
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,           -- year
            MIN([Date]) AS StartDate,       -- Earliest trading day of the year
            MAX([Date]) AS EndDate          -- latest trading day of the year
        FROM
            nflx
        WHERE
            [Date] <= '2024-04-30'          -- limited to match the spy table
        GROUP BY
            YEAR([Date])
    ),
    StartEndPrices AS
    (
        SELECT
            yp.Year,                                                        -- year
            CAST(nflx_start.[Close] AS DECIMAL(18, 2)) AS nflxStartPrice,       -- earliest closing price of the year
            CAST(nflx_end.[Close] AS DECIMAL(18, 2)) AS nflxEndPrice,           -- latest closing price of the year
            CAST(AVG(nflx.[Volume]) AS DECIMAL(18, 2)) AS nflxAvgVolume         -- average volume
        FROM
            YearlyPrices yp
                JOIN nflx AS nflx_start
                    ON yp.StartDate = nflx_start.[Date]
                JOIN nflx AS nflx_end
                    ON yp.EndDate = nflx_end.[Date]
                CROSS JOIN nflx
        WHERE
            nflx.[Date] BETWEEN yp.StartDate AND yp.EndDate
        GROUP BY
            yp.Year,
            nflx_start.[Close],
            nflx_end.[Close]
    )
SELECT
    Year,
    nflxStartPrice,
    nflxEndPrice,
    RTRIM(CAST(ROUND((((nflxEndPrice - nflxStartPrice) / nflxStartPrice) * 100), 1) AS DECIMAL(18, 1))) AS nflxPercentReturn,
    ROUND(CAST(nflxAvgVolume AS INT), 0) AS nflxAVGVolume
FROM
    StartEndPrices
ORDER BY
    Year;

--SPY annual returns since 2002
WITH YearlyPrices AS
    (
        SELECT
            YEAR([Date]) AS Year,               -- year
            MIN([Date]) AS StartDate,           -- Earliest trading day of the year
            MAX([Date]) AS EndDate              -- latest trading day of the year
        FROM
            spy
        WHERE
            [Date] >= '2002-05-23'              -- limited to match the nflx table
        GROUP BY
            YEAR([Date])
    ),
    StartEndPrices AS
    (
        SELECT
            yp.Year,                                                        -- year
            CAST(spy_start.[Close] AS DECIMAL(18, 2)) AS spyStartPrice,        -- earliest closing price of the year
            CAST(spy_end.[Close] AS DECIMAL(18, 2)) AS spyEndPrice,            -- latest closing price of the year
            CAST(AVG(spy.[Volume]) AS DECIMAL(18, 2)) AS spyAvgVolume          -- average volume
        FROM
            YearlyPrices yp
                JOIN spy AS spy_start
                    ON yp.StartDate = spy_start.[Date]
                JOIN spy AS spy_end
                    ON yp.EndDate = spy_end.[Date]
                CROSS JOIN spy
        WHERE
            spy.[Date] BETWEEN yp.StartDate AND yp.EndDate
        GROUP BY
            yp.Year,
            spy_start.[Close],
            spy_end.[Close]
    )
SELECT
    Year,
    spyStartPrice,
    spyEndPrice,
    RTRIM(CAST(ROUND((((spyEndPrice - spyStartPrice) / spyStartPrice) * 100), 1) AS DECIMAL(18, 1))) AS spyPercentReturn,
    ROUND(CAST(spyAvgVolume AS INT), 0) AS spyAVGVolume
FROM
    StartEndPrices
ORDER BY
    Year;

-- Calculate the current value of a $100 investment in NFLX on 2002-05-23
SELECT
    ROUND((100 / first_price.[Close]) * last_price.[Close], 2) AS investment_value, -- $54056.70
    ROUND(((100 / first_price.[Close]) * last_price.[Close] - 100) / 100 * 100, 0) AS percent_return    -- 53957 %
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
    ROUND((100 / first_price.[Close]) * last_price.[Close], 2) AS investment_value,                         -- $690.30
    ROUND(((100 / first_price.[Close]) * last_price.[Close] - 100) / 100 * 100, 0) AS percent_return        -- 590 %
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