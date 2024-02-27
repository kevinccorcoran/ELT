-- Drop the table if it already exists
DROP TABLE IF EXISTS raw.historical_daily_main;

-- Create table
CREATE TABLE raw.historical_daily_main (
    date TEXT,
    open TEXT,
    high TEXT,
    low TEXT,
    close TEXT,
    adj_close TEXT,
    volume TEXT,
    processed_at TEXT
);

