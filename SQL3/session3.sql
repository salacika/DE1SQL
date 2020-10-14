
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


-- Exercise1: Do the same with speed. If speed is NULL or speed < 100 create a "LOW SPEED" category, otherwise, mark as "HIGH SPEED". Use IF instead of CASE!

-- COUNT

-- COUNT(*)
SELECT COUNT(*) FROM birdstrikes;


-- COUNT(column)
SELECT COUNT(reported_date) FROM birdstrikes;


-- DISTINCT COUNT
-- how many distinct states we have
SELECT COUNT(DISTINCT(state)) FROM birdstrikes;


-- MAX, AVG, SUM

-- she sum of all repair costs of birdstrikes accidents
SELECT SUM(cost) FROM birdstrikes;

-- speed in this database is measured in KNOTS. Let's transform to KMH. 1 KNOT = 1.852 KMH
SELECT (AVG(speed)*1.852) as avg_kmh FROM birdstrikes;

-- how many observation days we have in birdstrikes
SELECT DATEDIFF(MAX(reported_date),MIN(reported_date)) from birdstrikes;

-- Exercise3: What was the lowest speed of aircrafts starting with 'H'

-- GROUP BY

-- one group: What is the highest speed by aircraft type?
SELECT MAX(speed), aircraft FROM birdstrikes GROUP BY aircraft;

-- multiple groups: Which state for which aircraft type paid the most repair cost?
SELECT state, aircraft, SUM(cost) AS sum FROM birdstrikes WHERE state !='' GROUP BY state, aircraft ORDER BY sum DESC;

-- Exercise4: Which phase_of_flight has the least of incidents?

-- Exercise5: What is the rounded highest average cost by phase_of_flight?

-- HAVING

-- lets say you have average speed by state
SELECT state, AVG(speed) AS avg_speed FROM birdstrikes GROUP BY state ;

-- and you want only avg_speed=50
SELECT state,AVG(speed) AS avg_speed FROM birdstrikes GROUP BY state WHERE ROUND(avg_speed) = 50;

SELECT state,AVG(speed) AS avg_speed FROM birdstrikes GROUP BY state HAVING ROUND(avg_speed) = 50;

-- before aggragetion filter
SELECT state,AVG(speed) AS avg_speed FROM birdstrikes WHERE state='Idaho' GROUP BY state HAVING ROUND(avg_speed) = 50;

-- Exercise6: What the highest AVG speed of the states with names less than 5 characters?



