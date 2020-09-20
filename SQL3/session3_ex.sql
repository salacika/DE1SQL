
-- EX1

SELECT aircraft, airline,speed,IF(speed < 100 OR SPEED IS NULL,'LOW SPEED','HIGH SPEED') AS speed_category  FROM  birdstrikes ORDER BY speed_category;


