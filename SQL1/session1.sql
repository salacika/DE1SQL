
-- CREATE DATABASE AND LOAD DATA

-- create  database / schema
CREATE SCHEMA firstdb;

-- not case sensitive
create schema FIRSTDB;

-- select database for further operations
USE firstdb;

-- deleteting database. execute twice
DROP SCHEMA firstdb;

-- instead
DROP SCHEMA IF EXISTS firstdb;

-- recreate db
CREATE SCHEMA birdstrikes;
USE birdstrikes ;

-- the place from where is allowed to load a CSV
SHOW VARIABLES LIKE "secure_file_priv";

-- create an empty table
CREATE TABLE birdstrikes 
(id INTEGER NOT NULL,
aircraft VARCHAR(32),
flight_date DATE NOT NULL,
damage VARCHAR(16) NOT NULL,
airline VARCHAR(255) NOT NULL,
state VARCHAR(255),
phase_of_flight VARCHAR(32),
reported_date DATE,
bird_size VARCHAR(16),
cost INTEGER NOT NULL,
speed INTEGER,PRIMARY KEY(id));

-- load data into that table (change the path if needed)
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/birdstrikes_small.csv' 
INTO TABLE birdstrikes 
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(id, aircraft, flight_date, damage, airline, state, phase_of_flight, @v_reported_date, bird_size, cost, @v_speed)
SET
reported_date = nullif(@v_reported_date, ''),
speed = nullif(@v_speed, '');


-- EXPLORING DB

-- list tables
SHOW TABLES;

-- structure of birdstrikes
DESCRIBE birdstrikes;

-- content of birdstrikes
SELECT * FROM birdstrikes;

-- retrive certain field(s):
SELECT cost FROM birdstrikes;
SELECT airline,cost FROM birdstrikes;

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










