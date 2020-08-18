# Session content:

[SQL in 5 Minutes](#5mins)

[Your first database](#firstdb)

[Your first SQL statements](#firstsql)

[Creating a free instance of MySQL in AWS Cloud](#aws)

[Dumping a database with MySQL Workbench](#dump)

[Replicating a database from local to AWS with MySQL Workbench](#replicate)

[Homework](#homework)  



<a name="5mins"/>


# SQL in 5 minutes

Browse to https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in

## Query 1
`SELECT * FROM customers;`

## Query 2
```
SELECT supplierName, COUNT(*) AS 'number of products' FROM suppliers
INNER JOIN products
	ON products.SupplierID = suppliers.SupplierID
GROUP BY suppliers.SupplierID;
```

## Query 3
```
SELECT 
	country.country_name,
	SUM(CASE WHEN call.id IS NOT NULL THEN 1 ELSE 0 END) AS calls,
	AVG(ISNULL(DATEDIFF(SECOND, call.start_time, call.end_time),0)) AS avg_difference
FROM country 
LEFT JOIN city ON city.country_id = country.id
LEFT JOIN customer ON city.id = customer.city_id
LEFT JOIN call ON call.customer_id = customer.id
GROUP BY 
	country.id,
	country.country_name
HAVING AVG(ISNULL(DATEDIFF(SECOND, call.start_time, call.end_time),0)) > (SELECT AVG(DATEDIFF(SECOND, call.start_time, call.end_time)) FROM call)
ORDER BY calls DESC, country.id ASC;
```

<a name="firstdb"/>
# Your first Database with Tables

Execute:
```
SHOW VARIABLES LIKE "secure_file_priv";
```

Copy https://github.com/salacika/DE1SQL/blob/master/SQL1/birdstrikes_small.csv in the folder resulted in the previous command. 

Then execute:

```
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

LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/birdstrikes_small.csv' 
INTO TABLE birdstrikes 
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(id, aircraft, flight_date, damage, airline, state, phase_of_flight, @v_reported_date, bird_size, cost, @v_speed)
SET
reported_date = nullif(@v_reported_date, ''),
speed = nullif(@v_speed, '');
```

<a name="firstsql"/>
# Your first SQL statements


List the table(s) of your database

`SHOW TABLES`

List the structure of a table

`DESCRIBE birdstrikes`

## Selecting data

Select all data

`SELECT * FROM birdstrikes`

`select * from birdstrikes`

Select certain field(s)

`SELECT cost FROM birdstrikes`

`SELECT airline,cost FROM birdstrikes`

<a name="aws"/>
# Creating a free instance of MySQL in AWS Cloud

[AWS CLoud help](https://github.com/salacika/DE1SQL/tree/master/SQL1/AWS)

<a name="dump"/>

# Dumping a database with MySQL Workbench

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/dump.png?raw=true)

<a name="replicate"/>

# Replicating a database from local to AWS with MySQL Workbench

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/replicate.png?raw=true)

<a name="homework"/>

# Homework

Using AWS Console
- Delete your AWS instance (without creating a backup)
- Check your AWS billing information and create a Budget alert for Actual and Forecasted Costs, with a budaget cap of 1$.

Using mysql console:
- Purge birdstrikes table (hint: TRUNCATE)
- Delete birdstrikes table (hint: DROP)
- Delete schema 

Using MySQL workbench:
- Import a datafile of your choosing into your local instance


SUBMIT SOLUTION FOR THE LAST 2 SECTIONS IN MODDLE.






