SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN marketCap IS NULL OR marketCap = '' THEN 1 ELSE 0 END) AS missing_marketCap,
    SUM(CASE WHEN totalRevenue IS NULL OR totalRevenue = '' THEN 1 ELSE 0 END) AS missing_totalRevenue,
    SUM(CASE WHEN profitMargins IS NULL THEN 1 ELSE 0 END) AS missing_profitMargins,
    SUM(CASE WHEN currentRatio IS NULL THEN 1 ELSE 0 END) AS missing_currentRatio,
    SUM(CASE WHEN pegRatio IS NULL OR pegRatio = ' ' THEN 1 ELSE 0 END) AS missing_pegRatio
FROM company_financials_raw;

-- marketCap Top 10 and Bottom 10
WITH ranked AS (
    SELECT 
        shortName,
        CAST(marketCap AS DECIMAL(20,2)) AS market_cap,
        RANK() OVER (ORDER BY CAST(marketCap AS DECIMAL(20,2)) DESC) AS overall_rank,
        COUNT(*) OVER () AS total_companies
    FROM company_financials_raw
    WHERE CAST(marketCap AS DECIMAL(20,2)) != 0
)
SELECT 
    CASE WHEN overall_rank <= 10 THEN 'Top 10' ELSE 'Bottom 10' END AS rank_type,
    overall_rank,
    shortName AS company,
    market_cap
FROM ranked
WHERE overall_rank <= 10 OR overall_rank > total_companies - 10
ORDER BY overall_rank;


-- totalRevenue Top 10 and Bottom 10
WITH ranked AS (
    SELECT 
        shortName,
        CAST(totalRevenue AS DECIMAL(20,2)) AS total_revenue,
        RANK() OVER (ORDER BY CAST(totalRevenue AS DECIMAL(20,2)) DESC) AS overall_rank,
        COUNT(*) OVER () AS total_companies
    FROM company_financials_raw
)
SELECT 
    CASE WHEN overall_rank <= 10 THEN 'Top 10' ELSE 'Bottom 10' END AS rank_type,
    overall_rank,
    shortName AS company,
    total_revenue
FROM ranked
WHERE overall_rank <= 10 OR overall_rank > total_companies - 10
ORDER BY overall_rank;


-- profitMargins Top 10 and Bottom 10
WITH ranked AS (
    SELECT 
        shortName,
        profitMargins,
        RANK() OVER (ORDER BY profitMargins DESC) AS overall_rank,
        COUNT(*) OVER () AS total_companies
    FROM company_financials_raw
)
SELECT 
    CASE WHEN overall_rank <= 10 THEN 'Top 10' ELSE 'Bottom 10' END AS rank_type,
    overall_rank,
    shortName AS company,
    profitMargins
FROM ranked
WHERE overall_rank <= 10 OR overall_rank > total_companies - 10
ORDER BY overall_rank;


-- currentRatio Top 10 and Bottom 10
WITH ranked AS (
    SELECT 
        shortName,
        currentRatio,
        RANK() OVER (ORDER BY currentRatio DESC) AS overall_rank,
        COUNT(*) OVER () AS total_companies
    FROM company_financials_raw
    WHERE currentRatio IS NOT NULL AND currentRatio != ' ' AND currentRatio > 0
)
SELECT 
    CASE WHEN overall_rank <= 10 THEN 'Top 10' ELSE 'Bottom 10' END AS rank_type,
    overall_rank,
    shortName AS company,
    currentRatio
FROM ranked
WHERE overall_rank <= 10 OR overall_rank > total_companies - 10
ORDER BY overall_rank;


-- pegRatio Top 10 and Bottom 10
WITH ranked AS (
    SELECT 
        shortName,
        pegRatio,
        RANK() OVER (ORDER BY pegRatio DESC) AS overall_rank,
        COUNT(*) OVER () AS total_companies
    FROM company_financials_raw
    WHERE pegRatio IS NOT NULL AND pegRatio != ' ' AND pegRatio > 0
)
SELECT 
    CASE WHEN overall_rank <= 10 THEN 'Top 10' ELSE 'Bottom 10' END AS rank_type,
    overall_rank,
    shortName AS company,
    pegRatio
FROM ranked
WHERE overall_rank <= 10 OR overall_rank > total_companies - 10
ORDER BY overall_rank;



-- Profitability vs. Liquidity--
SELECT 
	CASE
		WHEN currentRatio < 1 THEN 'Liquidity Risk'
        ELSE 'Adequate Liquidity'
	END AS liquidity_status,
    ROUND(AVG(CAST(marketCap AS DECIMAL (20,2))), 2) AS avg_market_cap,
    ROUND(AVG(profitMargins), 3) AS avg_profit_margin, 
    COUNT(*) AS num_companies
FROM company_financials_raw
GROUP BY liquidity_status;


-- totalCash and totalDebt Liquidity
WITH leverage AS (
    SELECT
        shortName,
        currentRatio,
        CAST(totalDebt AS DECIMAL(20,2)) AS total_debt,
        CAST(totalCash AS DECIMAL(20,2)) AS total_cash,
        CAST(totalDebt AS DECIMAL(20,2)) - CAST(totalCash AS DECIMAL(20,2)) AS net_debt,
        CAST(marketCap AS DECIMAL(20,2)) AS market_cap
    FROM company_financials_raw
    WHERE totalDebt IS NOT NULL AND totalCash IS NOT NULL
)
SELECT
    CASE WHEN currentRatio < 1 THEN 'Liquidity Risk' ELSE 'Adequate Liquidity' END AS liquidity_status,
    CASE WHEN net_debt > 0 THEN 'Net Debtor' ELSE 'Net Cash Position' END AS leverage_status,
    COUNT(*) AS num_companies,
    ROUND(AVG(net_debt), 2) AS avg_net_debt
FROM leverage
GROUP BY liquidity_status, leverage_status
ORDER BY liquidity_status, leverage_status, avg_net_debt;


-- Average profitability and valuation by industry
SELECT industry,
       COUNT(*) AS num_companies,
       ROUND(AVG(profitMargins), 3) AS avg_profit_margin,
       ROUND(AVG(pegRatio), 2) AS avg_peg_ratio,
       ROUND(AVG(currentRatio), 2) AS avg_current_ratio
FROM company_financials_raw
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY avg_profit_margin DESC;


-- Which industry has the most Liquidity Risk companies?
SELECT industry,
       COUNT(*) AS liquidity_risk_count
FROM company_financials_raw
WHERE currentRatio < 1.0
GROUP BY industry
ORDER BY liquidity_risk_count DESC;	


    