# New data from World Bank

We will add a new set of tables from a World Bank database (http://databank.worldbank.org/data/databases)

Normally this should be batch run of an .sql file. In our case this is the worldbank.sql added in this folder. This time we will run the content of the .sql file command by command. 

For each table we will do the following steps:

1. Run `CREATE TABLE table_name` command
2. `DESCRIBE table_name` (to check the table was indeed created)
3. `LOAD DATA INFILE ...` (to load the preloaded csv data into the table)
4. `SELECT * FROM table_name`

We will do these steps for 6 tables: cities, countries,languages,economies,currencies,populations

Before we start, lets make sure the loading won't fail, if in the csv we have empty values

`SET sql_mode = '';`

Now lets do the first table called `cities`

```
CREATE TABLE cities (
  city_name               VARCHAR(255),
  country_code            VARCHAR(255),
  city_proper_pop         REAL,
  metroarea_pop           REAL NULL,
  urbanarea_pop           REAL,
  PRIMARY KEY(city_name)
);
```
Check if the table was created

`DESCRIBE cities`

Load cities.csv preloaded on the HDD into cities table. The csv fields are delimited with ',' the entries with '\n' and the first line is header

`LOAD DATA INFILE '/var/lib/mysql-files/cities.csv' INTO TABLE cities FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES`

Check if the data was loaded

`SELECT * FROM cities`

Repeat this for the remaining 5 tables. 


# Conditional logic

## CASE

Syntax form

```
CASE expression
    WHEN test THEN result
    …
    ELSE otherResult
END
```

Lets create a new field base on surface and name it geosize_group

```
SELECT country_name, continent, country_code, surface_area,
    CASE 
        WHEN surface_area  > 2000000
            THEN 'large'
        WHEN  surface_area > 350000 AND surface_area <2000000
            THEN 'medium'
        ELSE 
            'small'
    END
    AS geosize_group   
FROM  countries
```

## Exercise 1

Select the populations records where year is 2015, create a new field AS popsize_group to organize population size into

* 'large' (> 50 million),

* 'medium' (> 1 million), and

* 'small' groups.

Select only the country code, population size, and this new popsize_group as fields.

# Joins

## INNER JOIN

Syntax form
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
```


Join all fields

```
SELECT *
FROM cities 
INNER JOIN countries 
ON cities.country_code = countries.country_code
```

Join selected fields. List all country codes from country tables which has related cities in city table. Show country code and city name. Order by country code. 
```
SELECT countries.country_code, cities.city_name
FROM cities 
INNER JOIN countries 
ON cities.country_code = countries.country_code
ORDER BY cities.country_code
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





