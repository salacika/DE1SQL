-- Exercise1: What state figures in the 145th line of our database?
SELECT * FROM birdstrikes LIMIT 145;
SELECT * FROM birdstrikes LIMIT 144,1;
-- Tennessee

-- Exercise2: What is flight_date of the latest birstrike in this database?
SELECT * FROM birdstrikes as b ORDER BY b.flight_date DESC;
-- 200-04018

-- Exercise3: What was the cost of the 50th most expensive damage?
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost LIMIT 49,1;
-- 86864

-- Exercise4: What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL;
-- ''

-- Exercise5:  How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
SELECT DATEDIFF(tab.flight_date, NOW()) FROM birdstrikes as tab WHERE weekofyear(tab.flight_date) =52 AND state="Colorado"
-- 7576
