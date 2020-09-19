

SELECT * FROM birdstrikes LIMIT 10;

SELECT * FROM birdstrikes LIMIT 10,1;


SELECT flight_date, DATEDIFF(flight_date,NOW()),weekofyear(flight_date) AS week  FROM birdstrikes WHERE weekofyear(flight_date) = 52;




SELECT DISTINCT(state) FROM birdstrikes WHERE LENGTH(state) = 5;


SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes WHERE cost < SQRT(speed/2) * 10 ORDER BY cost DESC;

SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes