-- SQL Query Explanation for Calculating Relative Strength Index (RSI) for Cryptocurrencies
--
-- The Relative Strength Index (RSI) is a momentum oscillator that measures the speed and change of price movements.
-- RSI oscillates between zero and 100. Traditionally, and according to Wilder, RSI is considered overbought when above 70 and oversold when below 30.
--
-- This SQL query performs the following operations:
-- 1. DailyPrices CTE:
--    - Retrieves daily prices for selected cryptocurrencies.
--    - Computes the price from the previous day using the LAG window function for later calculation of daily price changes.
--    - Filters data for the last 30 days to focus on recent price movements.
--
-- 2. PriceChanges CTE:
--    - Calculates the daily change in price by comparing each day's price to the previous day.
--    - Determines gains and losses separately. A gain occurs if the current day's price is higher than the previous day's, 
--      whereas a loss is recorded if it is lower.
--
-- 3. AverageGainsAndLosses CTE:
--    - Computes the average gain and the average loss over the typical RSI period of 14 days using a moving average.
--    - This moving average helps smooth out daily fluctuations and focuses on longer-term momentum trends.
--
-- 4. RSICalc CTE:
--    - Applies the RSI formula: 100 - (100 / (1 + (AvgGain / NULLIF(AvgLoss, 0)))).
--    - This formula calculates the RSI value by normalizing the ratio of average gains to average losses.
--    - The NULLIF function prevents division by zero, returning null if AvgLoss is zero.
--
-- 5. Final SELECT:
--    - Selects the SYMBOL (cryptocurrency), PriceDate, and RSI value.
--    - Filters for the most recent day to provide the latest RSI calculation.
--    - Orders the output by SYMBOL and PriceDate for clarity.
--
-- This query is intended to help traders and investors gauge the current momentum of cryptocurrencies and identify potential buy or sell signals based on RSI levels.
WITH DailyPrices AS (
  SELECT
    SYMBOL,
    RECORDED_AT :: date AS PriceDate,
    PRICE,
    LAG(PRICE) OVER (
      PARTITION BY SYMBOL
      ORDER BY
        RECORDED_AT
    ) AS PreviousPrice
  FROM
    osmosis.price.dim_prices
  WHERE
    SYMBOL IN (
      'STRD',
      'ATOM',
      'OSMO',
      'USDC',
      'ETH',
      'USDT',
      'BTC'
    )
    AND RECORDED_AT >= CURRENT_DATE - INTERVAL '30 days'
),
PriceChanges AS (
  SELECT
    SYMBOL,
    PriceDate,
    -- Including PriceDate here to carry it through
    PRICE,
    PreviousPrice,
    CASE
      WHEN PRICE > PreviousPrice THEN PRICE - PreviousPrice
      ELSE 0
    END AS Gain,
    CASE
      WHEN PRICE < PreviousPrice THEN PreviousPrice - PRICE
      ELSE 0
    END AS Loss
  FROM
    DailyPrices
  WHERE
    PreviousPrice IS NOT NULL
),
AverageGainsAndLosses AS (
  SELECT
    SYMBOL,
    PriceDate,
    -- Make sure to include PriceDate here as well
    AVG(Gain) OVER (
      PARTITION BY SYMBOL
      ORDER BY
        PriceDate ROWS BETWEEN 13 PRECEDING
        AND CURRENT ROW
    ) AS AvgGain,
    AVG(Loss) OVER (
      PARTITION BY SYMBOL
      ORDER BY
        PriceDate ROWS BETWEEN 13 PRECEDING
        AND CURRENT ROW
    ) AS AvgLoss
  FROM
    PriceChanges
),
RSICalc AS (
  SELECT
    SYMBOL,
    PriceDate,
    -- Carrying PriceDate to the final CTE
    100 - (100 / (1 + (AvgGain / NULLIF(AvgLoss, 0)))) AS RSI -- Calculate RSI
  FROM
    AverageGainsAndLosses
)
SELECT
  SYMBOL,
  PriceDate,
  RSI
FROM
  RSICalc
WHERE
  PriceDate = CURRENT_DATE - INTERVAL '1 day' -- Most recent complete day
ORDER BY
  SYMBOL,
  PriceDate DESC;
  