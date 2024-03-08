CREATE OR REPLACE FUNCTION calculate_growth(open NUMERIC, close NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN CASE
        WHEN open = 0 THEN NULL -- or return another value that suits your needs
        ELSE ((close - open) / open) * 100
    END;
END;
$$ LANGUAGE plpgsql;
