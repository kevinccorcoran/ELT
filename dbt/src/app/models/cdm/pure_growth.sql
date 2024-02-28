
-- Use the `ref` function to select from other models
 
WITH BASE_TABLE AS
	(SELECT date, TICKER,
			OPEN,
			HIGH,
			LOW,
			CLOSE,
			ADJ_CLOSE,
			VOLUME,
			PROCESSED_AT
		FROM {{ source('raw', 'historical_daily_main') }} ),
		
 MIN_MAX_DATE AS
	(SELECT TICKER,
			MIN(BT.DATE) AS MIN_DATE_OPEN,
			MAX(BT.DATE) AS MAX_DATE_close
		FROM BASE_TABLE BT WHERE TICKER = 'MSFT'

		GROUP BY TICKER)
SELECT date, bt.ticker, open, close
FROM BASE_TABLE BT
JOIN MIN_MAX_DATE MMD ON (BT.TICKER = MMD.TICKER
AND BT.DATE = MMD.MIN_DATE_OPEN ) 
or ( BT.TICKER = MMD.TICKER
AND BT.DATE = MAX_DATE_close )
--where id = 1