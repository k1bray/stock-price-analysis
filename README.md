# stock-price-analysis

https://www.kaggle.com/datasets/mayankanand2701/netflix-stock-price-dataset

https://www.kaggle.com/datasets/gkitchen/s-and-p-500-spy

# Table of Contents
[Summary of Project Intention](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#summary-of-project-intention)

[Dataset Examination and Profiling](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#dataset-examination-and-profiling)

[Cleaning and Manipulation of Data](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#cleaning-and-manipulation-of-data)

[Analysis and Discussion](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#analysis-and-discussion)

[Recommendations and Possible Further Actions Based on Analysis](https://github.com/k1bray/stock-price-analysis/blob/main/README.md#recommendations-and-possible-further-actions-based-on-analysis)

# Summary of Project Intention

The intended purpose of this project is to take a closer look at the traded price performance of Netflix (NFLX) since its IPO in May of 2002 through April of 2024.  This was done by calculating various metrics that utilize the available objective data.  A comparison was made to the performance of the overall market during the same period by using the Select Sector SPDRs ETF that tracks the S&P500 (ticker symbol: SPY).

### Tools Used for Analysis

There were multiple tools used in the process of this analysis.  Using a server on a local device, a database was created and facilitated through Microsoft SQL Server and manipulated through VSCode utilizing the T-SQL database language.  Microsoft Word was used as the main platform for writing and editing the report of the analysis.  Tableau Public Desktop was used to create the visuals.  GitHub Desktop and GitHub were used as a hosting source for the version control and final rendering of the project report for publication.


# Dataset Examination and Profiling

### Data Availability and License

The NFLX data can be accessed [here] and the dataset license can be viewed [here].
The SPY data can be accessed [here] and the dataset license can be viewed [here].

The tables used during this analysis had a similar format and consisted of quantitative, structed data with columns showing daily trading data for Date, Open, High, Low, Close, and Volume.  The SPY table contained additional columns parsing out the date components but were not used for the purposes of this project.
The SQL code that was used during all phases of this project can be seen [here] 

The schemas were checked for both tables and it was found that during the import process the datatypes for all columns in the NFLX table were set by default to varchar (50) and were adjusted accordingly.  The columns in the SPY table were imported using the proper datatypes and did not require any adjustment.
While calculating descriptive statistics of both tables it was verified that they were properly limited to the same start and end dates, as well as the same number of rows.  Thereby ensuring the accuracy of the data being used for the sake of performance comparison.
Both tables were checked for any NULL values, and none were found.
Both tables were checked for duplicate rows based on the ‘Date’ column, and none were found.

# Cleaning and Manipulation of Data

# Analysis and Discussion

# Recommendations and Possible Further Actions Based on Analysis
