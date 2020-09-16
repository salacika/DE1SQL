# Overview

**Teaching**: 90 min

**Problem statement**
1. In normalized database, the data is structured in a way to avoid data redundancy and support consistency. This strucure is not allways the best fit to analytics, most of the time you need to merge one or more tables to get the required data set. Joins is offering a solution for this problem.  


**Objectives**
* Understanding the basics of table relationships 
* Understanding relationship marking on database diagrams
* Understanding the difference between different joins
* Exercising joins



<br/><br/><br/>

# Table Content:
[Session setup](#setup)

[INNER joins](#inner)

[SELF joins](#self)

[LEFT joins](#left)

[Homework](#homework)  


<br/><br/><br/>
<a name="setup"/>
## Session setup

Install [sample database](/SQL5/sampledatabase_create.sql?raw=true) script. Credit: https://www.mysqltutorial.org/mysql-sample-database.aspx

#### Database diagram
![Database diagram](/SQL5/sampledatabase_diagram.png)

<br/><br/><br/>
<a name="inner"/>
## INNER joins

Syntax form
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
```


Join all fields of order and order details

```
SELECT * 
FROM orders 
INNER JOIN orderdetails 
ON orders.orderNumber = orderdetails.orderNumber;
```

Same think, but now join selected fields and create and synthetic column:
```
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;
```

## Exercise 2

List GDP per capita by spoken language. 

Hints: 
* you have to use economies and language table
* you have to aggregate by spoken language

## MULTIPLE INNER JOINS

Syntax form
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id
INNER JOIN another_table
ON left_table.id = another_table.id;
```

## Exercise 3
Using multiple inner joins list city names, belonging country, capital of the country and inflation rate for the given country. In which city we had the lowest inflation? Send me the SQL query and the city name.


## USING

This how we can inner join countries with languages
```
SELECT *
FROM countries 
INNER JOIN languages 
ON countries.country_code = languages.country_code
```

The is how we count the number of result records for the previous query
```
SELECT COUNT(*)
FROM countries 
INNER JOIN languages 
ON countries.country_code = languages.country_code
```

Now, there is a shorcut if the key of the left table and the key of the right table has the same name:

```
SELECT COUNT(*)
FROM countries 
INNER JOIN languages 
USING (country_code)
```

## SELF JOIN

In cities table we have 2 cities for United Arab Emirates (ARE):

`SELECT country_code,city_name FROM cities WHERE country_code = 'ARE'`  

Let's create a list with all combination these 2 cities

```
SELECT p1.country_code, 
       p1.city_name as city1,
       p2.city_name as city2
FROM cities AS p1
INNER JOIN cities AS p2
USING(country_code)
WHERE country_code = 'ARE' 
ORDER BY country_code
```

## LEFT JOIN

Inner join countries and currencies from North America

```
SELECT country_name, region, basic_unit
FROM countries
INNER JOIN currencies
USING (country_code)
WHERE region = 'North America' 
ORDER BY region;
```

Same with left join

```
SELECT country_name,region, basic_unit
FROM countries
LEFT JOIN currencies
USING (country_code)
WHERE region = 'North America' 
ORDER BY region;
```

Same with left join and null check 

```
SELECT country_name, region, basic_unit
FROM countries
LEFT JOIN currencies
USING (country_code)
WHERE region = 'North America' AND currencies.country_code IS NULL
ORDER BY region;
```

## Exercise 4
Left join countries with economies. List country_name, region, gdp_percapita for the first 5 records of year 2010. 


## RIGHT JOIN

Rarely used. It is a mirror of left join. Previous exercise with right join: 

```
SELECT country_name, region, gdp_percapita
FROM economies 
RIGHT JOIN countries 
USING(country_code)
where year = 2010 LIMIT 5;
```





