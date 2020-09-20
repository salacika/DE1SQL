# Chapter 3 - Overview

**Teaching**: 90 min

**Problem statement**
1. As analyst ...


**Objectives**
* ..



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


<br/><br/><br/>
<a name="db"/>
## CONDITONAL LOGIC

#### CASE

Syntax form

```
CASE expression
    WHEN test THEN result
    …
    ELSE otherResult
END
```

Lets create a new field based on cost

```
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
```

<br/><br/>
### `Exercise1` 
### Do the same with speed. If speed is NULL or speed < 100 create a "LOW SPEED" category, otherwise, mark as "HIGH SPEED". Use IF instead of CASE!


<br/><br/><br/>
<a name="altering"/>
## Groupping and aggregation

#### COUNT

Counting the number of records

`COUNT(*)` - counts the number of records

`SELECT COUNT(*) FROM birdstrikes;`

`COUNT(column)` - counts the number of not NULL records for the given column

`SELECT COUNT(reported_date) FROM birdstrikes;`

#### DISTINCT

How do we list all distinct states? (Remember last seminar!)

`SELECT DISTINCT(state) FROM birdstrikes;`

Count number of distinct states

`SELECT COUNT(DISTINCT(state)) FROM birdstrikes;`

<br/><br/>
### `Exercise2` 
### How many distinct 'aircraft' we have in the database?
<br/><br/>

#### MAX, AVG, SUM 

The sum of all repair costs of birdstrikes accidents

`SELECT SUM(cost) FROM birdstrikes;`

Speed in this database is measured in KNOTS. Let's transform to KMH. 1 KNOT = 1.852 KMH

`SELECT (AVG(speed)*1.852) as avg_kmh FROM birdstrikes;`

How many observation days we have in birdstrikes

`SELECT DATEDIFF(MAX(reported_date),MIN(reported_date)) from birdstrikes;`


<br/><br/>
### `Exercise3` 
### List the lowest speed and aircraft where the implicated aircraft was 'C' and rename it to 'lowest_speed'. What is the resulting lowest speed?
<br/><br/>



#### GROUP BY

What is the lowest speed by aircraft type?

`SELECT MIN(speed), aircraft from birdstrikes group by aircraft;`


<br/><br/>
### `Exercise3` 
### Which phase_of_flight has the least of incidents? 
<br/><br/>


### `Exercise4` 
### What is the highest average cost by phase_of_flight?
<br/><br/>



Multiple aggregate functions

`SELECT state, aircraft, COUNT(*), MAX(cost), MIN(cost), AVG(cost) FROM birdstrikes WHERE state LIKE 'A%' GROUP BY state, aircraft ORDER BY state, aircraft;`

`SELECT aircraft, state, MAX(cost) AS max_cost FROM birdstrikes GROUP BY state ORDER BY state;`

Let's fix it:

`SELECT state, aircraft, MAX(cost) AS max_cost FROM birdstrikes GROUP BY state, aircraft ORDER BY state, aircraft;`

#### HAVING

What if I want AVG speed for states which has 'island' on their name:

`SELECT AVG(speed),state FROM birdstrikes GROUP BY state WHERE state LIKE '%island%';`

Crashbummbang! The correct keyword after GROUP BY is HAVING

`SELECT AVG(speed),state FROM birdstrikes GROUP BY state HAVING state LIKE '%island%';`


<br/><br/>
### `Exercise5` 
### What the highest AVG speed of the states with names less than 5 characters?
<br/><br/>


<br/><br/><br/>
<a name="homework"/>
# Homework

* Submit into Moodle the solutions for Exercise 1 to 5. 
* Make sure to submit both the SQL statements and answers to the questions
* The required data format for submission is a .sql file








