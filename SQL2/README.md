# Chapter 2 - Overview

**Teaching**: 90 min

**Problem statement**
1. As analyst, you would like to make sure your data stored can be accesed only by authorized persons.
2. As analyst, you would like to query your database to obtain data required for your analytics.


**Objectives**
* Understanding the options of altering a db
* Introduction to database security
* Understanding datatypes
* Exercising database queries



<br/><br/><br/>

# Table Content:
[Chapter's database](#db)

[Altering your first database](#altering)

[Users and privileges](#users)

[More advanced selects](#selects)

[Data types](#datatypes)  

[Comparison Operators](#operators)  

[Filtering with VARCHAR](#VARCHAR)  

[Filtering with INT](#INT)  

[Filtering with DATE](#DATE)  

[Homework](#homework)  


<br/><br/><br/>
<a name="db"/>
## Chapter's database

No need to load new data, in this chapter we will use only the birdstrikes table loaded in the last chapter:


![Database diagram](/SQL1/db_model.png)

<br/><br/><br/>
<a name="altering"/>
## Altering your first database

#### Copy table

```
CREATE TABLE new_birdstrikes LIKE birdstrikes;
SHOW TABLES;
DESCRIBE new_birdstrikes;
SELECT * FROM new_birdstrikes;
```

#### Delete table

`DROP TABLE IF EXISTS new_birdstrikes;`


#### Create table

`CREATE TABLE employee (id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));`

`DESCRIBE employee;`

#### Insert new rows (records)

Insert lines in employee table one by one

```
INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');
```

Let's check the results

`SELECT * FROM employee;`

What happens if you try this (and why)?

`INSERT INTO employee (id,employee_name) VALUES(3,'Student4');`

#### Updating rows

`UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '1';`

`UPDATE employee SET employee_name='The Other Arnold' WHERE id = '2';`

Let's check the results

`SELECT * FROM employee;`

#### Deleting rows

Deleting some records

`DELETE FROM employee WHERE id = 3;`

Let's check the results

`SELECT * FROM employee`

#### Deleting rows
`TRUNCATE employee;`

Let's check the results

`SELECT * FROM employee;`




<br/><br/><br/>
<a name="users"/>
## Users and privileges

#### Creating new user
`CREATE USER 'laszlosallo'@'%' IDENTIFIED BY 'laszlosallo1';`

#### Giving full rights for table employee
`GRANT ALL ON birdstrikes.employee TO 'laszlosallo'@'%';`

#### Giving rights to see one column of birdstrikes
`GRANT SELECT (state) ON birdstrikes.birdstrikes TO 'laszlosallo'@'%';`

#### Deleting user
`DROP USER 'laszlosallo'@'%';`


<br/><br/><br/>
<a name="selects"/>
## More advanced selects

#### New column
Create a new column

`SELECT *, speed/2 FROM birdstrikes;`

#### Aliasing

`SELECT *, speed/2 AS halfspeed FROM birdstrikes;`


#### Using Limit

List the first 10 records

`SELECT * FROM birdstrikes LIMIT 10;`

List the first 1 record, after the the first 10

`SELECT * FROM birdstrikes LIMIT 10,1;`


<br/><br/>
### `Exercise1` 
### What state figures in the 145th line of our database?
<br/><br/>


#### Ordering data

Order by a field

`SELECT state, cost FROM birdstrikes ORDER BY cost;`

Order by a multiple fields

`SELECT state, cost FROM birdstrikes ORDER BY state, cost ASC;`

Reverse ordering

`SELECT state, cost FROM birdstrikes ORDER BY cost DESC;`


<br/><br/>
### `Exercise2` 
### What is the date of the newest birstrike in this database?
<br/><br/>




#### Unique values 

Of a column

`SELECT DISTINCT damage FROM birdstrikes;`

Unique pairs

`SELECT DISTINCT airline, damage FROM birdstrikes;`


<br/><br/>
### `Exercise3` 
### What was the cost of the 100th most expensive damage?
<br/><br/>


#### Filtering
Select the lines where states is Alabama

`SELECT * FROM birdstrikes WHERE state = 'Alabama';`



<br/><br/><br/>
<a name="datatypes"/>
## Data types

![Data types](/SQL2/data_types.png)


<br/><br/><br/>
<a name="operators"/>
## Comparison Operators

![Data types](/SQL2/ops.png)



<br/><br/><br/>
<a name="VARCHAR"/>
## Filtering with VARCHAR

#### NOT EQUAL

Select the lines where states is not Alabama

`SELECT * FROM birdstrikes WHERE state != 'Alabama'`

States starting with 'A'

#### LIKE

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'A%';`

Note the case (in)sensitivity

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'a%';`

States starting with 'ala'

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'ala%';`

States starting with 'North ' followed by any character, followed by an 'a', followed by anything

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'North _a%';`

States not starting with 'A'

`SELECT DISTINCT state FROM birdstrikes WHERE state NOT LIKE 'a%' ORDER BY state;`


#### Logical operators

Filter by multiple conditions

`SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small';`

`SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Missouri';`

#### IS NOT NULL

Filtering out nulls and empty strings

`SELECT * FROM birdstrikes WHERE state IS NOT NULL AND state != '';`

#### IN

What if I need 'Alabama', 'Missouri','New York','Alaska'? Should we concatenate 4 AND filters?

`SELECT * FROM birdstrikes WHERE state IN ('Alabama', 'Missouri','New York','Alaska');`

#### LENGTH
Listing states with 5 characters

`SELECT DISTINCT(state) FROM birdstrikes WHERE LENGTH(state) = 5;`


<br/><br/><br/>
<a name="INT"/>
## Filtering with INT

Speed equals 350

`SELECT * FROM birdstrikes WHERE speed = 350;`

Speed equal or more than 25000

`SELECT * FROM birdstrikes WHERE speed >= 25000;`

#### ROUND, SQRT

`SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes;`

#### BETWEEN

`SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40;`




<br/><br/>
### `Exercise4` 
### What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?


<br/><br/><br/>
<a name="DATE"/>
## Filtering with DATE

Date is "2000-01-02"

`SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02";`

All entries where flight_date is between "2000-01-01" AND "2000-01-03"

`SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03';`

#### BETWEEN

`SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03";`


<br/><br/>
### `Exercise5` 
### How many days ellapsed between now and flight dates happening in week 52? (Hint: used DATEDIFF, WEEKOFYEAR)


<br/><br/><br/>
<a name="homework"/>
# Homework

* Submit into Moodle the solutions for Exercise 1 to 5. 
* Make sure to submitboth the SQL statements and answers to the questions
* The requied data format for submission is a .sql file



