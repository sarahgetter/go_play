-- Momentum of cryptocurrency prices. Momentum in trading
-- typically refers to the rate of acceleration of a security's
-- price or volume – essentially measuring the speed at which
-- the price is changing.
--
-- This SQL query will calculate the 5-day moving average
-- of the price changes to gauge short-term momentum, and
-- compare it with a 30-day moving average to understand
-- longer-term trends. By comparing these two, you can get
-- an idea of whether short-term movements are aligning with
-- or diverging from longer-term trends, which could indicate
-- potential buy or sell signals.
--
-- DailyPrices CTE: Computes daily prices and the price of the previous day.
--
-- PriceChanges CTE: Calculates the daily percentage change for each token.
--
-- MovingAverages CTE: Computes the 5-day and 30-day moving averages of daily price changes for each symbol.
--
-- Final SELECT:
-- Compares short-term momentum (5-day MA) against long-term momentum (30-day MA).
-- Assigns a trend indicator, which could be useful for traders looking at momentum strategies.
--
-- This query provides an analytical view that can help traders or analysts identify if a cryptocurrency is currently
-- experiencing a momentum that is stronger or weaker than its recent trend, aiding in making more informed trading decisions.

WITH DailyPrices AS (
    SELECT
        SYMBOL,
        RECORDED_AT::date AS PriceDate,
        PRICE,
        LAG(PRICE, 1) OVER (PARTITION BY SYMBOL ORDER BY RECORDED_AT) AS PreviousPrice
    FROM osmosis.price.dim_prices
    WHERE SYMBOL IN ('STRD', 'ATOM', 'OSMO', 'USDC', 'ETH', 'USDT', 'BTC')
      AND RECORDED_AT >= CURRENT_DATE - INTERVAL '60 days' -- Extending period for more robust MA calculation
),

PriceChanges AS (
    SELECT
        SYMBOL,
        PriceDate,
        PRICE,
        (PRICE - PreviousPrice) / PreviousPrice AS DailyChangePercent
    FROM DailyPrices
    WHERE PreviousPrice IS NOT NULL
),

MovingAverages AS (
    SELECT
        SYMBOL,
        PriceDate,
        AVG(DailyChangePercent) OVER (PARTITION BY SYMBOL ORDER BY PriceDate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS ShortTermMomentum,  -- 5-day moving average
        AVG(DailyChangePercent) OVER (PARTITION BY SYMBOL ORDER BY PriceDate ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS LongTermMomentum  -- 30-day moving average
    FROM PriceChanges
)

SELECT
    SYMBOL,
    PriceDate,
    ShortTermMomentum,
    LongTermMomentum,
    CASE
        WHEN ShortTermMomentum > LongTermMomentum THEN 'Bullish Divergence'
        WHEN ShortTermMomentum < LongTermMomentum THEN 'Bearish Divergence'
        ELSE 'Neutral'
    END AS TrendIndicator
FROM MovingAverages
WHERE PriceDate = CURRENT_DATE - INTERVAL '1 day'  -- Most recent complete day
ORDER BY SYMBOL, PriceDate DESC;
