USE stock_price_analysis;

-- Calculating the mean daily return, standard deviation, and the percentage of days that NFLX traded within 1 STD in various timeframes
-- Creating the temporary table for DailyReturns
DROP TABLE IF EXISTS #DailyReturns;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns
FROM
    nflx
WHERE 
    Date >= '2002-05-23';

-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics;
SELECT
    AVG(DailyReturn) AS MeanReturn,
    STDEV(DailyReturn) AS StdDevReturn
INTO #Statistics
FROM
    #DailyReturns;

-- Verify the temp table
SELECT *
FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn,                                                               -- 0.0017655471521395053
    S.StdDevReturn,                                                             -- 0.03529804878917651
    S.MeanReturn - S.StdDevReturn AS LowerBound,                                -- -0.033532501637037
    S.MeanReturn + S.StdDevReturn AS UpperBound,                                -- 0.037063595941316016
    COUNT(D.Date) AS DaysWithinOneStdDev,                                       -- 4510
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*) FROM #DailyReturns), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev                                        -- 81.4

FROM
    #DailyReturns D
CROSS JOIN
    #Statistics S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn - S.StdDevReturn) AND (S.MeanReturn + S.StdDevReturn)
GROUP BY
    S.MeanReturn, S.StdDevReturn, S.MeanReturn - S.StdDevReturn, S.MeanReturn + S.StdDevReturn;

-- Drop the temporary tables
DROP TABLE #DailyReturns;
DROP TABLE #Statistics;

/*
MeanReturn:This is the average (mean) daily return for the period of data.

StdDevReturn: This is the standard deviation of the daily returns. It measures the amount of variation or dispersion of the 
returns from the mean return. In your case, it's approximately 0.0353, indicating that the daily returns tend to deviate from 
the mean by about 0.0353 on average.

LowerBound: This is the lower bound of the trading range within one standard deviation from the mean return. It's calculated 
as the mean return minus the standard deviation.

UpperBound: This is the upper bound of the trading range within one standard deviation from the mean return. It's calculated 
as the mean return plus the standard deviation.

DaysWithinOneStdDev: This is the count of days where the daily return falls within the trading range defined by one standard 
deviation from the mean return. In your case, there are 4510 days within this range.

In summary, the analysis indicates that for the given period and data, about 4510 days had daily returns that fell within one 
standard deviation from the mean return, with a mean return of approximately 0.00177 and a standard deviation of approximately 0.0353.









Let's break down the meaning of each column in the result:

MeanReturn: This is the average (mean) daily return for the period of your data. In this case, it's approximately $0.00177, 
which means that, on average, each day Netflix's stock price increased by about $0.00177.

StdDevReturn: This is the standard deviation of the daily returns. It measures the amount of variation or dispersion 
of the returns from the mean return. In this case, it's approximately $0.0353. This means that the daily returns tend to 
deviate from the mean by about $0.0353 on average.

LowerBound: This is the lower bound of the trading range within one standard deviation from the mean return. It's calculated as 
the mean return minus the standard deviation. In this case, it's approximately $-0.0335.

UpperBound: This is the upper bound of the trading range within one standard deviation from the mean return. It's calculated as 
the mean return plus the standard deviation. In this case, it's approximately $0.0371.

DaysWithinOneStdDev: This is the count of days where the daily return falls within the trading range defined by one 
standard deviation from the mean return. In this case, there are 4510 days within this range.

PercentageWithinOneStdDev: This is the percentage of trading days where the daily return falls within the trading range 
defined by one standard deviation from the mean return. In this case, it's approximately 81.4%. This means that out of all 
the trading days analyzed, approximately 81.4% of them had daily returns that fell within one standard deviation from the mean return.

So, to summarize, the analysis indicates that for the given period and data:

The average daily return was approximately 0.00177 units.
The standard deviation of the daily returns was approximately 0.0353 units.
The trading range within one standard deviation from the mean return was approximately -0.0335 to 0.0371 units.
Approximately 81.4% of the trading days had daily returns that fell within this trading range.










MeanReturn of approximately $0.00177 means that, on average, each day Netflix's stock price increased by about $0.00177.

StdDevReturn of approximately $0.0353 means that the daily returns tend to deviate from the mean by about $0.0353 on average.

LowerBound of approximately $-0.0335 and UpperBound of approximately $0.0371 define the trading range within one standard 
deviation from the mean return.

The PercentageWithinOneStdDev remains the same, representing the percentage of trading days where the daily return falls within 
the trading range defined by one standard deviation from the mean return.
*/

-- Create the temporary table for DailyReturns for the past 6 months
DROP TABLE IF EXISTS #DailyReturns6;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns6
FROM
    nflx
WHERE 
    Date >= DATEADD(MONTH, -6, GETDATE());


-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics6;
SELECT
    AVG(DailyReturn) AS MeanReturn6,
    STDEV(DailyReturn) AS StdDevReturn6
INTO #Statistics6
FROM
    #DailyReturns6;

-- Verify the temp table
-- SELECT *
-- FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn6,
    S.StdDevReturn6,
    S.MeanReturn6 - S.StdDevReturn6 AS LowerBound6,
    S.MeanReturn6 + S.StdDevReturn6 AS UpperBound6,
    COUNT(D.Date) AS DaysWithinOneStdDev6,
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*)
    FROM #DailyReturns6), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev

FROM
    #DailyReturns6 D
CROSS JOIN
    #Statistics6 S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn6 - S.StdDevReturn6) AND (S.MeanReturn6 + S.StdDevReturn6)
GROUP BY
    S.MeanReturn6, S.StdDevReturn6, S.MeanReturn6 - S.StdDevReturn6, S.MeanReturn6 + S.StdDevReturn6;

-- Drop the temporary tables
DROP TABLE #DailyReturns6;
DROP TABLE #Statistics6;


-- Create the temporary table for DailyReturns for the past 12 months
DROP TABLE IF EXISTS #DailyReturns12;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns12
FROM
    nflx
WHERE 
    Date >= DATEADD(MONTH, -12, GETDATE()); -- Select data from the past 12 months

-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics12;
SELECT
    AVG(DailyReturn) AS MeanReturn12,
    STDEV(DailyReturn) AS StdDevReturn12
INTO #Statistics12
FROM
    #DailyReturns12;

-- Verify the temp table
-- SELECT *
-- FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn12,
    S.StdDevReturn12,
    S.MeanReturn12 - S.StdDevReturn12 AS LowerBound12,
    S.MeanReturn12 + S.StdDevReturn12 AS UpperBound12,
    COUNT(D.Date) AS DaysWithinOneStdDev12,
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*)
    FROM #DailyReturns12), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev

FROM
    #DailyReturns12 D
CROSS JOIN
    #Statistics12 S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn12 - S.StdDevReturn12) AND (S.MeanReturn12 + S.StdDevReturn12)
GROUP BY
    S.MeanReturn12, S.StdDevReturn12, S.MeanReturn12 - S.StdDevReturn12, S.MeanReturn12 + S.StdDevReturn12;

-- Drop the temporary tables
DROP TABLE #DailyReturns12;
DROP TABLE #Statistics12;



-- Create the temporary table for DailyReturns for the past 24 months
DROP TABLE IF EXISTS #DailyReturns24;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns24
FROM
    nflx
WHERE 
    Date >= DATEADD(MONTH, -24, GETDATE());
-- Select data from the past 12 months

-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics24;
SELECT
    AVG(DailyReturn) AS MeanReturn24,
    STDEV(DailyReturn) AS StdDevReturn24
INTO #Statistics24
FROM
    #DailyReturns24;

-- Verify the temp table
-- SELECT *
-- FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn24,
    S.StdDevReturn24,
    S.MeanReturn24 - S.StdDevReturn24 AS LowerBound24,
    S.MeanReturn24 + S.StdDevReturn24 AS UpperBound24,
    COUNT(D.Date) AS DaysWithinOneStdDev24,
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*)
    FROM #DailyReturns24), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev

FROM
    #DailyReturns24 D
CROSS JOIN
    #Statistics24 S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn24 - S.StdDevReturn24) AND (S.MeanReturn24 + S.StdDevReturn24)
GROUP BY
    S.MeanReturn24, S.StdDevReturn24, S.MeanReturn24 - S.StdDevReturn24, S.MeanReturn24 + S.StdDevReturn24;

-- Drop the temporary tables
DROP TABLE #DailyReturns24;
DROP TABLE #Statistics24;









-- Create the temporary table for DailyReturns for the past 36 months
DROP TABLE IF EXISTS #DailyReturns36;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns36
FROM
    nflx
WHERE 
    Date >= DATEADD(MONTH, -36, GETDATE());
-- Select data from the past 12 months

-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics36;
SELECT
    AVG(DailyReturn) AS MeanReturn36,
    STDEV(DailyReturn) AS StdDevReturn36
INTO #Statistics36
FROM
    #DailyReturns36;

-- Verify the temp table
-- SELECT *
-- FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn36,
    S.StdDevReturn36,
    S.MeanReturn36 - S.StdDevReturn36 AS LowerBound36,
    S.MeanReturn36 + S.StdDevReturn36 AS UpperBound36,
    COUNT(D.Date) AS DaysWithinOneStdDev36,
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*)
    FROM #DailyReturns36), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev

FROM
    #DailyReturns36 D
CROSS JOIN
    #Statistics36 S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn36 - S.StdDevReturn36) AND (S.MeanReturn36 + S.StdDevReturn36)
GROUP BY
    S.MeanReturn36, S.StdDevReturn36, S.MeanReturn36 - S.StdDevReturn36, S.MeanReturn36 + S.StdDevReturn36;

-- Drop the temporary tables
DROP TABLE #DailyReturns36;
DROP TABLE #Statistics36;









-- Create the temporary table for DailyReturns for the past 48 months
DROP TABLE IF EXISTS #DailyReturns48;
SELECT
    Date,
    [Close],
    LAG([Close]) OVER (ORDER BY Date) AS PreviousClose,
    (CAST([Close] AS FLOAT) - LAG([Close]) OVER (ORDER BY Date)) / LAG([Close]) OVER (ORDER BY Date) AS DailyReturn
INTO #DailyReturns48
FROM
    nflx
WHERE 
    Date >= DATEADD(MONTH, -48, GETDATE());
-- Select data from the past 12 months

-- Creating a temporary table for Statistics
DROP TABLE IF EXISTS #Statistics48;
SELECT
    AVG(DailyReturn) AS MeanReturn48,
    STDEV(DailyReturn) AS StdDevReturn48
INTO #Statistics48
FROM
    #DailyReturns48;

-- Verify the temp table
-- SELECT *
-- FROM #Statistics;

-- Creating TradingRange and count days within one standard deviation
SELECT
    S.MeanReturn48,
    S.StdDevReturn48,
    S.MeanReturn48 - S.StdDevReturn48 AS LowerBound48,
    S.MeanReturn48 + S.StdDevReturn48 AS UpperBound48,
    COUNT(D.Date) AS DaysWithinOneStdDev48,
    CAST(ROUND((COUNT(D.Date) * 100.0) /
        (SELECT COUNT(*)
    FROM #DailyReturns48), 1) AS DECIMAL(5,1)) 
            AS PercentageWithinOneStdDev

FROM
    #DailyReturns48 D
CROSS JOIN
    #Statistics48 S
WHERE 
    D.DailyReturn BETWEEN (S.MeanReturn48 - S.StdDevReturn48) AND (S.MeanReturn48 + S.StdDevReturn48)
GROUP BY
    S.MeanReturn48, S.StdDevReturn48, S.MeanReturn48 - S.StdDevReturn48, S.MeanReturn48 + S.StdDevReturn48;

-- Drop the temporary tables
DROP TABLE #DailyReturns48;
DROP TABLE #Statistics48;