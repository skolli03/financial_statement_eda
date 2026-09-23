CREATE DATABASE company_fin;
USE company_fin;

CREATE TABLE company_financials_raw (
	sr_no TEXT,
    shortName TEXT,
    industry TEXT,
    ebitdaMargins TEXT,
    profitMargins TEXT,
    grossMargins TEXT,
    operatingCashflow TEXT,
    revenueGrowth TEXT,
    operatingMargins TEXT,
    ebitda TEXT,
    grossProfits TEXT,
    freeCashflow TEXT,
    currentPrice TEXT,
    earningsGrowth TEXT,
    currentRatio TEXT,
    returnOnAssets TEXT,
    debtToEquity TEXT,
    returnOnEquity TEXT,
    totalCash TEXT,
    totalDebt TEXT,
    totalRevenue TEXT,
    totalCashPerShare TEXT,
    financialCurrency TEXT,
    revenuePerShare TEXT,
    quickRatio TEXT,
    quoteType TEXT,
    symbol TEXT,
    enterpriseToRevenue TEXT,
    enterpriseToEbitda TEXT,
    forwardEps TEXT,
    sharesOutstanding TEXT,
    bookValue TEXT,
    trailingEps TEXT,
    priceToBook TEXT,
    heldPercentInsiders TEXT,
    enterpriseValue TEXT,
    earningsQuarterlyGrowth TEXT,
    pegRatio TEXT,
    forwardPE TEXT,
    marketCap TEXT
);

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/suraj/OneDrive/Desktop/SQL/EDA Project/Data/financialdata.csv'
INTO TABLE company_financials_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM company_financials_raw;

	