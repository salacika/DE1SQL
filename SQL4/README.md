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

#### Syntax 
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
```


#### Basic forms
Join all fields of products and productlines details

```
SELECT * 
FROM products 
INNER JOIN productlines  
ON products.productline = productlines.productline;
```

Same thing, but now with USING:
```
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
USING(productline);
```

Same thing with aliasing:
```
SELECT *
FROM products t1
INNER JOIN productlines t2 
USING(productline);
```

#### Select specific columns
```
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;
```

<br/><br/>
### `Exercise1` 
#### Join all fields of order and orderdetails


### `Exercise2` 
#### Join all fields of order and orderdetails. Display only orderNumber, status and sum of totalsales (quantityOrdered * priceEach) for each orderNumber. 

<br/>



### Multiple INNER joins

#### Syntax 
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id
INNER JOIN another_table
ON left_table.id = another_table.id;
```

<br/>
### `Exercise3` 
### We want to how the emplyoees are performing. Join orders, customers and employees and return orderDate,lastName, firstName
<br/>

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





