
-- ALTERING DB


-- copy table (structure)
CREATE TABLE new_birdstrikes LIKE birdstrikes;
SHOW TABLES;
DESCRIBE new_birdstrikes;
SELECT * FROM new_birdstrikes;

-- delete table
DROP TABLE IF EXISTS new_birdstrikes;

-- create table
CREATE TABLE employee (id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));
DESCRIBE employee;
SELECT * FROM employee;

-- insert new rows (records)
INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');
SELECT * FROM employee;

-- What happens if you try this (and why)?
INSERT INTO employee (id,employee_name) VALUES(3,'Student4');

-- updating rows
UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '1';
UPDATE employee SET employee_name='The Other Arnold' WHERE id = '2';
SELECT * FROM employee;

-- deleting rows
DELETE FROM employee WHERE id = 3;
SELECT * FROM employee;

-- empty table
TRUNCATE employee;
SELECT * FROM employee;


-- USERS AND PRIVILEGES

-- create user
CREATE USER 'laszlosallo'@'%' IDENTIFIED BY 'laszlosallo1';

-- full rights on one table
GRANT ALL ON birdstrikes.employee TO 'laszlosallo'@'%';

-- access only one column
GRANT SELECT (state) ON birdstrikes.birdstrikes TO 'laszlosallo'@'%';

-- delete user
DROP USER 'laszlosallo'@'%';


-- SELECTS

-- create a new column
SELECT *, speed/2 FROM birdstrikes;

-- aliasing
SELECT *, speed/2 AS halfspeed FROM birdstrikes;

-- using Limit
-- list the first 10 records
SELECT * FROM birdstrikes LIMIT 10;

-- list the first 1 record, after the the first 10
SELECT * FROM birdstrikes LIMIT 10,1;

-- Exercise1: What state figures in the 145th line of our database?

-- ordering data
SELECT state, cost FROM birdstrikes ORDER BY cost;
SELECT state, cost FROM birdstrikes ORDER BY state, cost ASC;
SELECT state, cost FROM birdstrikes ORDER BY cost DESC;

-- Exercise2: What is the date of the newest birstrike in this database?

-- unique values
SELECT DISTINCT damage FROM birdstrikes;

-- unique pairs
SELECT DISTINCT airline, damage FROM birdstrikes;

-- Exercise3: What was the cost of the 100th most expensive damage?

-- filtering
SELECT * FROM birdstrikes WHERE state = 'Alabama';

-- DATATYPES

-- COMPARISON OPERATORS

-- VARCHAR

-- LIKE
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'A%';

-- note the case (in)sensitivity
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'a%';

-- states starting with 'ala'
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'ala%';

-- states starting with 'North ' followed by any character, followed by an 'a', followed by anything
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'North _a%';

-- states not starting with 'A'
SELECT DISTINCT state FROM birdstrikes WHERE state NOT LIKE 'a%' ORDER BY state;

-- logical operators
SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small';
SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Missouri';

-- IS NOT NULL
-- filtering out nulls and empty strings
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND state != '';

-- IN
-- what if I need 'Alabama', 'Missouri','New York','Alaska'? Should we concatenate 4 AND filters?
SELECT * FROM birdstrikes WHERE state IN ('Alabama', 'Missouri','New York','Alaska');

-- LENGTH
-- listing states with 5 characters
SELECT DISTINCT(state) FROM birdstrikes WHERE LENGTH(state) = 5;



-- INT

-- speed equals 350
SELECT * FROM birdstrikes WHERE speed = 350;

-- speed equal or more than 25000
SELECT * FROM birdstrikes WHERE speed >= 25000;

-- ROUND, SQRT
SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes;

-- BETWEEN
SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40;


-- Exercise4: What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?



-- DATE
-- date is "2000-01-02"
SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02";

-- all entries where flight_date is between "2000-01-01" AND "2000-01-03"
SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03';

-- BETWEEN
SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03";

-- Exercise5: How many days elapsed between now and flight dates happening in week 52? (Hint: used DATEDIFF, WEEKOFYEAR)








