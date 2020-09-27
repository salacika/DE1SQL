
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

-- the place from where is allowed to load a CSV
SHOW VARIABLES LIKE "secure_file_priv";

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

-- second schema for dump
CREATE SCHEMA second;










