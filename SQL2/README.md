

## Selecting data

Select all data

`SELECT * FROM birdstrikes`

`select * from birdstrikes`

Select certain field

`SELECT cost FROM birdstrikes`

Select certain fields

`SELECT bird_size, cost FROM birdstrikes`

Create a new column

`SELECT *, speed/2 FROM birdstrikes`

Select all & limit

`SELECT * FROM birdstrikes LIMIT 10`

### Exercise 1: What state figures in the 145th line of our database?

## Ordering data

Order by a field

`SELECT state, cost FROM birdstrikes ORDER BY cost`

Order by a multiple fields

`SELECT state, cost FROM birdstrikes ORDER BY state, cost ASC`

Reverse ordering

`SELECT state, cost FROM birdstrikes ORDER BY cost DESC`

Reverse ordering by multiple fields

`SELECT state, cost FROM birdstrikes ORDER BY state DESC, cost`

### Exercise 2: What is the date of the newest birstrike in this database?

## Select unique values 

Of a column

`SELECT DISTINCT damage FROM birdstrikes`

Unique pairs

`SELECT DISTINCT airline, damage FROM birdstrikes`

### Exercise3: What was the cost of the 100th most expensive damage?


## Filtering data

Filter by field value

`=` equal

`<>` not equal (standard SQL)

`!=` not equal

`<` less than

`>` greater than

`<=` less than or equal to

`>=` greater than or equal to

#### VARCHAR

Select the lines where states is Alabama

`SELECT * FROM birdstrikes WHERE state = 'Alabama'`

Select the lines where states is not Alabama

`SELECT * FROM birdstrikes WHERE state != 'Alabama'`

States starting with 'A'

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'A%'`

Note the case (in)sensitivity

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'a%'`

States starting with 'ala'

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'ala%'`

States starting with 'North ' followed by any character, followed by an 'a', followed by anything

`SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'North _a%'`

States not starting with 'A'

`SELECT DISTINCT state FROM birdstrikes WHERE state NOT LIKE 'a%' ORDER BY state`


#### INT

Speed equals 350

`SELECT * FROM birdstrikes WHERE speed = 350`

Speed equal or more than 25000

`SELECT * FROM birdstrikes WHERE speed >= 25000`

Cost is equal with half of the speed

`SELECT * FROM birdstrikes WHERE cost = speed/2 * 10 ORDER BY cost DESC`


#### DATE

Date is "2000-01-02"

`SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02"`

Date is less than "2000-01-02"

`SELECT * FROM birdstrikes WHERE flight_date < "2000-01-02"`


#### NULL 

`SELECT * FROM birdstrikes WHERE speed IS NULL`

`SELECT * FROM birdstrikes WHERE speed IS NOT NULL`


## LOGICAL OPERATORS 

Filter by multiple conditions

`SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small'`

`SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Missouri'`

### Exercise 4: What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?

Filtering out empty strings as well

`SELECT * FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL AND state != ''`

## IN

What if i need 'Alabama', 'Missouri','New York','Alaska'? Should we concatenate 4 AND filters?

`SELECT * FROM birdstrikes WHERE state IN ('Alabama', 'Missouri','New York','Alaska')`

## BETWEEN

All entries where flight_date is between "2000-01-01" AND "2000-01-03"

`SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03'`

Or using BETWEEN for range operations

`SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03"`

Works with integers as well

`SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40`


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

