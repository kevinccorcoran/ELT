CREATE TABLE IF NOT EXISTS `raw.historical_daily_master`
(
    date DATE,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC,
    adjclose NUMERIC,
    volume INT64
)
