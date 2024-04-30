-- This query calculates the percentage change in the price of each cryptocurrency over a specified period, such as the past week or month.

WITH PriceChanges AS (
    SELECT 
        SYMBOL, -- Column representing the cryptocurrency symbol.
        PRICE, -- Latest price of the cryptocurrency.
        LAG(PRICE, 1) OVER (PARTITION BY SYMBOL ORDER BY RECORDED_AT) AS PreviousPrice, -- Previous price for comparison, using the LAG window function.
        RECORDED_AT -- Date when the price was recorded.
    FROM 
        osmosis.price.dim_prices -- Specifies the 'dim_prices' table in the 'price' schema of the 'osmosis' database.
    WHERE 
        RECORDED_AT >= CURRENT_DATE - INTERVAL '30 days' -- Filters records for the last 30 days.
)
SELECT 
    SYMBOL, -- Column representing the cryptocurrency symbol.
    RECORDED_AT AS Date, -- Date of the recorded price change.
    ((PRICE - PreviousPrice) / PreviousPrice) * 100 AS PercentageChange -- Calculates the percentage change from the previous price to the current price.
FROM 
    PriceChanges -- Uses the previously defined CTE 'PriceChanges' which contains the symbol, current and previous prices.
WHERE 
    PreviousPrice IS NOT NULL -- Filters out records where there is no previous price available, which prevents division by zero.
ORDER BY 
    SYMBOL, Date; -- Orders the results by the cryptocurrency symbol and the date in ascending order.
