
-- Exercise5: How many days elapsed between now and flight dates happening in week 52? (Hint: used DATEDIFF, WEEKOFYEAR)
SELECT flight_date, DATEDIFF(flight_date,NOW()),weekofyear(flight_date) AS week  FROM birdstrikes WHERE WEEKOFYEAR(flight_date) = 52;