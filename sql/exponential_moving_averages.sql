-- SQL Query for Calculating Exponential Moving Average (EMA) for Cryptocurrencies
--
-- The Exponential Moving Average (EMA) is a type of moving average that places a greater weight
-- and significance on the most recent data points. Unlike simple moving averages, EMAs respond
-- more quickly to price changes, which can be particularly useful in fast-moving markets like
-- cryptocurrencies. EMA is commonly used to gauge the direction of a trend, with shorter period
-- EMAs reacting faster than longer ones.
--
-- This query performs the following operations:
-- 1. Prices CTE:
--    - Retrieves the latest 30 days of price data for specified cryptocurrencies.
--    - Calculates the price on the previous day using the LAG window function.
--
-- 2. EMA_Calc CTE:
--    - Calculates the Exponential Moving Average using a smoothing factor (Alpha).
--    - The EMA formula used is: EMA_today = (Alpha * Price_today) + ((1 - Alpha) * EMA_yesterday).
--    - Alpha is set to 0.1, representing the degree of weighting decrease, a constant smoothing factor
--      between 0 and 1. A higher Alpha discounts older observations faster.
--    - The COALESCE function is used to handle the first data point where no previous EMA exists.
--      In such cases, the current price is used as the EMA.
--
-- The final SELECT statement:
--    - Outputs the SYMBOL, Date of the record, and its calculated EMA.
--    - Orders the results by SYMBOL and date in descending order to view the most recent data first.
--
-- This EMA calculation provides insights into potential trends and reversals in cryptocurrency prices,
-- aiding traders and analysts in making informed decisions based on the latest market data.

WITH Prices AS (
    SELECT 
        SYMBOL,
        RECORDED_AT,
        PRICE,
        LAG(PRICE) OVER (PARTITION BY SYMBOL ORDER BY RECORDED_AT) AS PreviousPrice
    FROM osmosis.price.dim_prices
    WHERE RECORDED_AT >= CURRENT_DATE - INTERVAL '30 days'
),
EMA_Calc AS (
    SELECT
        SYMBOL,
        RECORDED_AT,
        PRICE,
        0.1 AS Alpha, -- Smoothing factor, adjust as needed
        COALESCE(
            0.1 * PRICE + 0.9 * LAG(PRICE) OVER (PARTITION BY SYMBOL ORDER BY RECORDED_AT),
            PRICE
        ) AS EMA
    FROM Prices
)
SELECT 
    SYMBOL,
    RECORDED_AT AS Date,
    EMA
FROM EMA_Calc
ORDER BY SYMBOL, RECORDED_AT DESC;
