<p align="center"><img src="https://github.com/k1bray/stock-price-analysis/blob/main/Visuals/netflix_white_background.jpg" /></p>

# Introduction
Netflix began as an idea in 1997 by Reed Hastings and Marc Randolph that would give consumers the ability to rent DVDs through the mail via a website instead of having to go to a store.  Their website and business officially launched in 1998 with their subscription service coming soon after in 1999 that offered unlimited DVD rentals without due dates, late fees, or monthly rental limits.  The company was brought public on May 23, 2002, with an initial public offering (IPO) on NASDAQ for the ticker symbol: NFLX.  Innovative features to the user experience over the years, such as a personalized movie recommendation system based on customer’s movie ratings, and successfully transitioning the company’s focus to streaming services has helped to bolster revenue as well as the stock price to its current level.  

### Disclaimer
This report is for informational purposes only and should not be considered financial advice. The information presented is based on publicly available data and does not constitute a recommendation to buy or sell any securities, including NFLX stock. Investing involves inherent risks, and you should always conduct your own research and due diligence before making any investment decisions. Consider consulting with a qualified financial advisor to discuss your specific investment goals and risk tolerance.

# Table of Contents
[Summary of Project Intention](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#summary-of-project-intention)

[Dataset Examination and Profiling](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#dataset-examination-and-profiling)

[Cleaning and Manipulation of Data](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#cleaning-and-manipulation-of-data)

[Analysis and Discussion](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#analysis-and-discussion)

[Conclusion and Possible Further Actions Based on Analysis](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#conclusion-and-possible-further-actions-based-on-analysis)

# Summary of Project Intention

The intended purpose of this project is to take a closer look at the traded price performance of Netflix (NFLX) since its IPO in May of 2002 through April of 2024.  This was done by calculating various metrics that utilize the available objective data.  A comparison was made to the performance of the overall market during the same period by using the Select Sector SPDRs ETF that tracks the S&P500 (ticker symbol: SPY).

### Tools Used for Analysis

There were multiple tools used in the process of this analysis.  Using a server on a local device, a database was created and facilitated through **Microsoft SQL Server** and manipulated through **VSCode** utilizing the **T-SQL** database language.  **Microsoft Word** was used as the main platform for writing and editing the report of the analysis.  **Tableau Public Desktop** was used to create the visuals.  **GitHub Desktop** and **GitHub** were used as a hosting source for the version control and final rendering of the project report for publication.


# Dataset Examination and Profiling

### Data Availability and License

The NFLX data can be accessed [here](https://www.kaggle.com/datasets/mayankanand2701/netflix-stock-price-dataset) and the dataset license can be viewed [here](https://www.mit.edu/~amini/LICENSE.md).

The SPY data can be accessed [here](https://www.kaggle.com/datasets/gkitchen/s-and-p-500-spy) and the dataset license can be viewed [here](https://www.apache.org/licenses/LICENSE-2.0).

The tables used during this analysis had a similar format and consisted of quantitative, structed data with columns showing daily trading data for Date, Open, High, Low, Close, and Volume.  The SPY table contained additional columns parsing out the date components but were not used for the purposes of this project.

The SQL code that was used during all phases of this project can be seen [here](https://github.com/k1bray/stock-price-analysis/tree/main/SQL%20Files). 

The schemas were checked for both tables and it was found that during the import process the datatypes for all columns in the NFLX table were set by default to varchar (50) and were adjusted accordingly.  The columns in the SPY table were imported using the proper datatypes and did not require any adjustment.
While calculating descriptive statistics of both tables it was verified that they were properly limited to the same start and end dates, as well as the same number of rows.  Thereby ensuring the accuracy of the data being used for the sake of performance comparison.
Both tables were checked for any NULL values, and none were found.
Both tables were checked for duplicate rows based on the ‘Date’ column, and none were found.

# Cleaning and Manipulation of Data

The name of the NFLX table was changed from ‘nflx_stock_price’ to simply ‘nflx’ to match the naming convention of the ‘spy’ table as well as to ease query writing.

The columns in the NFLX table schema were adjusted to their proper datatypes.

The ‘Adj Close’ column in the NFLX table was found to be identical with the ‘Close’ column and was removed from the table.

The extra date-related columns in the SPY table were removed.

# Analysis and Discussion

The dates included in the comparison analysis between NFLX and SPY were standardized to ensure that the same period was being considered for each table.  Specifically, between May 23, 2002 (the IPO for NFLX), and April 30, 2024 (the limit of the dataset available for SPY).

Some general exploratory data analysis was done by calculating summary statistics.  Both tables were examined while finding values for the averages of opening and closing prices over the trading life of NFLX, as well as the minimum and maximum values of highs and lows.  However, given the range of values that NFLX has held since its IPO, as well as the amount of time that has passed since, the application of those calculations is limited to an exercise for the analytical theory that frames this report.

### The 30-, 50-, and 200-day simple moving averages were calculated and charted.

![NFLX vs SPY with SMA]( https://github.com/k1bray/stock-price-analysis/blob/main/Visuals/nflx_vs_spy_sma.png)

Please click [here](https://public.tableau.com/app/profile/kevin.bray/viz/NFLXvsSPYwSMA/Dashboard1) for an interactive version of the chart above.

A trader/investor can utilize a simple moving average (SMA) to make various decisions or determinations about an individual tradeable product, or even the overall market.  Moving averages of various time periods can be used to determine or verify trends, or potential changes in trends.  In very general terms, the trend is bullish if the values of the moving average are increasing while the traded values of the stock are higher than the moving average values, and bearish if the opposite is true.  However, as will be explained below, the length of the moving average period can be adjusted and needs to be considered within the appropriate context of the trading/investing goals and outlook held by the individual.

Simple moving averages can be used to determine levels of support and resistance for technical analysis of stock charts.  Stock trading values tend to “bounce” off SMA lines and act as either lower support in a bullish trend or upper resistance in a bearish trend.

When multiple moving averages of different time frames are utilized, they can act as potential indicators for buy or sell signals in relation to changes in trend or price change momentum.  When a shorter-term SMA crosses above a longer-term SMA, this could be interpreted as a buy signal, or what is called a “Golden Cross”.  An example of a golden cross can be seen using the NFLX chart on 11/14/2023 when the 30-day SMA crossed over the 50-day SMA.  Conversely, a shorter-term SMA crossing below a longer-term SMA could be a sell signal, or what is referred to as a “Death Cross”.  An example of a death cross can be seen using the NFLX chart on 08/02/2019 when the 30-day, 50-day, and 200-day SMA all inverted.

Crossing SMAs could also be applied to a situation where a trader wants to incorporate a stop-loss strategy.  This can be done on many modern trading platforms where a sell order could be triggered by a set of conditions being met, such as a short-term SMA crossing below a longer-term SMA.

Moving averages of different time periods can be useful in different types of trading.  For example, using a 20- and 30-day SMA together can be useful for short-term swing trading, while a 50- and 200-day SMA can be used together for more longer-term trading.

Since no single indicator should be used in technical analysis as the sole basis for either a buy or sell signal, moving averages can often act as confirmation signals when used in conjunction with other technical indicators.

### The running historical volatility was calculated using a 30-day timeframe and charted.

![NFLX vs SPY with HV]( https://github.com/k1bray/stock-price-analysis/blob/main/Visuals/nflx_vs_spy_hv.png "NFLX vs SPY with HV")

Please click [here](https://public.tableau.com/app/profile/kevin.bray/viz/NFLXvsSPYwHV/Dashboard1)  for an interactive version of the chart above.

Historical volatility (HV) is a measure of the extent to which the price of an asset has fluctuated over a given time period ([Investopedia.com](https://www.investopedia.com/terms/h/historicalvolatility.asp)).

The HV value is significant to trading and investing for several different reasons.  One way that it can be used is to assess the potential risk of an individual asset.  An asset with a higher HV value would be one that has historically shown a potential for higher price swings, which some traders/investors might view as having higher risk.  Conversely, an asset that has historically experienced smaller price swings would have a lower HV value and could be interpreted as having a lower risk level.  However, it should also be noted that some tradeable products will show swings in volatility as well as price.  Some stocks enter periods of lower HV that can precede a significant price move in reaction to a major news event, such as leading up to a corporate announcement before releasing an earnings report, announcement of an anticipated product launch, anticipated macroeconomic policy events, or FDA drug approval.  It should also be noted that the qualification of the concept of a security being considered either high or low risk is perspective-dependent and tied closely to the intentions and viewpoints of the individual investor/trader.  Different levels of perceived risk are appropriate for different types of trading/investing.  Stocks with higher HV can be attractive to short-term swing and day traders, while stocks with lower HV can be attractive to more conservative traders with a longer-term investment horizon.  In this way, HV values for a particular stock, or the overall market, can help traders/investors make informed decisions regarding strategy and outlook.

HV, as a backward-looking metric of volatility, is different from Implied Volatility (IV) which is a forward-looking metric of volatility.  IV is used in the pricing of option contracts on equities and indices ([Investopedia.com](https://www.investopedia.com/ask/answers/032515/what-options-implied-volatility-and-how-it-calculated.asp)).  However, the two can be compared to try and find instances of potential mispricing of options, which may be considered undervalued when HV is higher than IV and overvalued when the opposite is true.

### How often in a specified timeframe does NFLX trade within 1 SD?

Standard deviation (SD) is a statistical measure of how spread-out data points are from the mean (average) of a dataset ([Investopedia.com](https://www.investopedia.com/terms/s/standarddeviation.asp)).  In terms of this study, the concept of SD is being used to measure how often a stock trades within a 1 SD range from its daily average in a specified amount of time.

One function of SD is that it can be used as a measurement of volatility.  A stock that trades less often within 1 SD indicates that the stock is more volatile because it more often fluctuates further away from its average with larger price moves and swings.  Lower volatility stocks have higher instances of trading ranges closer to, or within 1 SD of, their averages.  The frequency of movement within 1 SD can be used as a tool to assess potential risk based on that measure of volatility.  Stocks that tend to fluctuate significantly and trade outside of 1 SD are seen as having higher volatility or carrying more risk.  As previously discussed, the perspective of risk is dependent upon the intentions and outlook of the individual trader/investor.  

Another function of SD that is useful for traders/investors is that it can be used to identify potential outliers, as well as aiding in predictive modeling.  Some stocks can trade outside of 1 SD in reaction to significant news events, such as an earnings announcement.  These moves can also be used to forecast future price movements.  The studying of past movements around events can give traders/investors a feel for the “personality” of a stock that could potentially give some insight into how a stock might react in the future to similar events.

The data shows that NFLX has historically traded within 1 standard deviation of its average price for a significant portion of the timeframes studied. This suggests some level of consistency that could be interpreted as having lower volatility, but it's important to remember that past performance isn't a guarantee of future results. High volatility can still occur within 1 SD.  However, the data shows that the daily mean returns were positive across all time periods considered.  This points toward a long-term upward trend (or, positive drift) in NFLX's price, which can be appealing for a buy-and-hold strategy.

The results of an analysis of NFLX frequency of days trading within 1 SD are as follows:

- Since IPO = 81.4% of trading days
- Previous 6 months = 76.9% of trading days
- Previous 12 months = 77.9% of trading days
- Previous 24 months = 79.6% of trading days
- Previous 36 months = 83.2% of trading days
- Previous 48 months = 81.9% of trading days

### How often in a given timeframe does SPY trade within 1 SD?

The data shows that SPY has historically traded within 1 standard deviation of its average price for a similar or slightly smaller portion of the timeframes considered when compared to NFLX. While this suggests NFLX may have been statistically more consistent in terms of staying within 1 SD when compared to SPY, it's important to remember that both stocks and ETF’s can still experience significant price movements within that range.

The results of an analysis of SPY frequency of days trading within 1 SD are as follows:

- Since NFLX IPO = 80.1% of trading days
- Previous 6 months = 66.7% of trading days
- Previous 12 months = 68.6% of trading days
- Previous 24 months = 71.9% of trading days
- Previous 36 months = 71.9% of trading days
- Previous 48 months = 72.7% of trading days

### Calculating Annual Returns

The annual percentage return was calculated for each year since the NFLX IPO.  A point to note is that returns for both the years 2002 and 2024 were based on incomplete periods.
 

![NFLX vs SPY Annual % Return]( https://github.com/k1bray/stock-price-analysis/blob/main/Visuals/nflx_vs_spy_annual_pct_return.png)

Please click [here](https://public.tableau.com/app/profile/kevin.bray/viz/NFLXvsSPYannualreturn/Dashboard1) for an interactive version of the chart above.

The chart above highlights a trend towards greater stability in NFLX's annual percentage returns over the past decade compared to its earlier years. However, it's important to remember and re-state that past performance is not a guarantee of future results.

While NFLX has historically delivered higher annual returns than SPY (as shown over their publicly traded lifetimes), SPY's returns appear to be more consistent, potentially reflecting the lower volatility that was discussed earlier in the report. However, traders/investors should always bear in mind that the stock market itself, even a broad index-tracking ETF like SPY, carries inherent risk that needs to be kept in context and properly respected.

### Hypothetical Investment

To better assess the historical long-term performance of NFLX stock, the potential return was analyzed using a hypothetical $100 investment made on the IPO date, May 23, 2002 (split-adjusted). The results show that a $100 investment in NFLX on that date would be worth approximately $54,056.70 as of April 30, 2024, representing a significant gain of over 53,957%. This demonstrates the substantial long-term growth of NFLX stock over the past 22 years.

For comparison, the same calculations were made using data from SPY with the same starting date and a hypothetical $100 investment. This investment would be worth approximately $690.30 as of April 30, 2024, representing a 590% appreciation in value. While NFLX shows impressive growth, it's important to remember the context of this analysis. SPY's performance reflects the overall market's growth during this period, showcasing a more typical investment experience.


# Conclusion and Possible Further Actions Based on Analysis

It's important to once again emphasize that past performance is not indicative of future results.  Netflix's historical growth trajectory may not be sustainable without continued innovation and adaptation.  To gain a deeper understanding of the company's potential, further analysis of both quantitative and qualitative factors regarding the company’s performance in the marketplace is recommended.
