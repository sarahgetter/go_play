-- This SQL query retrieves the highest (HistoricalHigh) and lowest (HistoricalLow) recorded prices 
-- for each stock symbol (SYMBOL) from the 'dim_prices' table within the 'price' schema of the 'osmosis' database.
-- The data is filtered to include only the prices recorded in the last year, ensuring that the results
-- reflect recent price fluctuations. The results are grouped by each stock symbol to calculate the maximum
-- and minimum prices recorded for that symbol during the specified time frame. Finally, the output is
-- ordered by the stock symbol in ascending order to facilitate easy lookup or reporting.
SELECT 
    SYMBOL,                         -- Column representing the stock symbol.
    MAX(PRICE) AS HistoricalHigh,   -- The maximum price of the stock in the last year.
    MIN(PRICE) AS HistoricalLow     -- The minimum price of the stock in the last year.
FROM 
    osmosis.price.dim_prices        -- Specifies the 'dim_prices' table in the 'price' schema of the 'osmosis' database.
WHERE 
    RECORDED_AT >= CURRENT_DATE - INTERVAL '1 year'  -- Filters records to the last year from today's date.
GROUP BY 
    SYMBOL                          -- Groups the results by each stock symbol.
ORDER BY 
    SYMBOL;                         -- Orders the results by the stock symbol in ascending order.
