-- DailyPrices CTE: This prepares data by calculating daily
-- prices and the price of the previous day.
--
-- PriceChanges CTE: This calculates the daily percentage change
-- for each token.
--
-- Final SELECT:
-- SYMBOL: Lists the token symbol.
-- AvgPrice: Calculates the average price over the selected period.
-- Volatility: Computes the standard deviation of the daily price changes,
-- representing the volatility.
-- DaysCounted: Counts the number of days that had a valid previous
-- day price for calculation.
--
-- What this analysis provides:
-- Volatility (Standard Deviation): A higher standard deviation indicates
-- greater price volatility, which can be interpreted as higher risk.
-- Investors and traders can use this information to assess risk levels
-- and potentially adjust their strategies or portfolio balances.
-- Average Price: Gives a sense of the average level at which the token
-- has been trading.
-- Days Counted: Indicates the number of days the calculation was based on,
-- which helps validate the robustness of the volatility measure.
-- This query will give you a comprehensive view of how risky each
-- cryptocurrency is in terms of price fluctuations over the past month. 

WITH DailyPrices AS (
    SELECT
        SYMBOL,
        RECORDED_AT::date AS PriceDate,
        PRICE,
        LAG(PRICE) OVER (PARTITION BY SYMBOL ORDER BY RECORDED_AT) AS PreviousPrice
    FROM osmosis.price.dim_prices
    WHERE SYMBOL IN ('STRD', 'ATOM', 'OSMO', 'USDC', 'ETH', 'USDT', 'BTC')
      AND RECORDED_AT >= CURRENT_DATE - INTERVAL '30 days'
),

PriceChanges AS (
    SELECT
        SYMBOL,
        PriceDate,
        PRICE,
        PreviousPrice,
        (PRICE - PreviousPrice) / PreviousPrice * 100 AS DailyChange
    FROM DailyPrices
    WHERE PreviousPrice IS NOT NULL
)

SELECT
    SYMBOL,
    AVG(PRICE) AS AvgPrice,
    STDDEV(DailyChange) AS Volatility,  -- Standard Deviation of Daily Price Changes
    COUNT(*) AS DaysCounted  -- Number of days with price data
FROM PriceChanges
GROUP BY SYMBOL
ORDER BY Volatility DESC;
