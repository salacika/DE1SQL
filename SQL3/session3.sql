
-- CASE

SELECT * FROM birdstrikes.birdstrikes;


SELECT aircraft, airline, cost, 
    CASE 
        WHEN cost  = 0
            THEN 'NO COST'
        WHEN  cost >0 AND cost < 100000
            THEN 'MEDIUM COST'
        ELSE 
            'HIGH COST'
    END
    AS cost_category   
FROM  birdstrikes
ORDER BY cost_category;

-- COUNT

-- COUNT(*)
SELECT COUNT(*) FROM birdstrikes;

-- COUNT(column)
SELECT COUNT(reported_date) FROM birdstrikes;


-- DISTINCT

-- distinct states
SELECT DISTINCT(state) FROM birdstrikes;

-- how many distinct states we have
SELECT COUNT(DISTINCT(state)) FROM birdstrikes;


-- MAX, AVG, SUM

-- she sum of all repair costs of birdstrikes accidents
SELECT SUM(cost) FROM birdstrikes;

-- speed in this database is measured in KNOTS. Let's transform to KMH. 1 KNOT = 1.852 KMH
SELECT (AVG(speed)*1.852) as avg_kmh FROM birdstrikes;

-- how many observation days we have in birdstrikes
SELECT DATEDIFF(MAX(reported_date),MIN(reported_date)) from birdstrikes;


-- GROUP BY

-- one group
SELECT MIN(speed), aircraft from birdstrikes group by aircraft;

-- multiple groups (who paid the most repair cost?)
SELECT state, aircraft, SUM(cost) AS sum FROM birdstrikes WHERE state !='' GROUP BY state, aircraft ORDER BY sum DESC;

-- HAVING

SELECT AVG(speed) AS avg_speed,state FROM birdstrikes GROUP BY state WHERE ROUND(avg_speed) = 50;

SELECT AVG(speed) AS avg_speed,state FROM birdstrikes GROUP BY state HAVING ROUND(avg_speed) = 50;



