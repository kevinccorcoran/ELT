DROP TABLE IF EXISTS cdm.pure_growth;

-- Create table
CREATE TABLE raw.historical_daily_master (
    date TEXT,
    open TEXT,
    high TEXT,
    low TEXT,
    close TEXT,
    adj_close TEXT,
    volume TEXT,
    processed_at TEXT
);