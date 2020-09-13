# Overview

**Teaching**: 90 min

**Problem statement**
1. As analyst, you are working on DB with corrupted data. Cleaning/fixing it requires extensive business logic. 
2. As analyst, you are running several very similar and heavy(long) quires, which differs from each other only by a few parameters. Maintaining these queries is a nightmare.

How do you propose to solve these problems?

**Objectives**
* Introducing procedural elements of SQL databases
* Introducing Stored Procedures with parameters
* Introducing IF/LOOP/CURSOR
* Understanding the difference of processing data in the database vs outside of of database engine
* Understanding the advantages and disadvantages of stored procedures
* Example with fixing data



<br/><br/><br/>

# Table Content:
[Session setup](#setup)

[A basic stored procedure](#basic)

[A stored procedures with parameters](#parameter)

[Example with IF and declaring variables](#if)

[Iterating with LOOP](#loops)

[Iterating trough a table with CURSOR](#cursor)

[Advantages/disadvantages of stored procedures](#advantages)

[Homework](#homework)  


<br/><br/><br/>
<a name="setup"/>
## Session setup

Install [sample database](/SQL5/sampledatabase_create.sql?raw=true) script. Credit: https://www.mysqltutorial.org/mysql-sample-database.aspx

#### Database diagram
![Database diagram](/SQL5/sampledatabase_diagram.png)

<br/><br/><br/>
<a name="basic"/>
## A basic stored procedure

#### Creating the stored procedure

```
DROP PROCEDURE IF EXISTS GetAllProducts;

DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT *  FROM products;
END //

DELIMITER ;
```
`NOTE1:` Mind the delimiter: the default delimiter in SQL is ";". In a stored procedure, you'll have potentially multiple statements ending with ";" - so you need the define a second delimiter to end the whole stored procedure. On the end of the routine, we will set the default delimiter back to ";"

`NOTE2:` You cannot edit a stored procedure, once created, you need to drop and recreate: `DROP PROCEDURE IF EXISTS ...` 


#### Executing the stored procedure

`CALL GetAllProducts();`


<br/><br/><br/>
<a name="paramter"/>
## A stored procedures with parameters


#### Input parameter with IN

The following example creates a stored procedure that finds all offices that locate in a country specified by the input parameter countryName
```
DROP PROCEDURE IF EXISTS GetOfficeByCountry;

DELIMITER //

CREATE PROCEDURE GetOfficeByCountry(
	IN countryName VARCHAR(255)
)
BEGIN
	SELECT * 
 		FROM offices
			WHERE country = countryName;
END //
DELIMITER ;
```

#### Executing with multiple parameters

`CALL GetOfficeByCountry('USA');`

`CALL GetOfficeByCountry('France');`

`CALL GetOfficeByCountry();` - you will get error, because the paramter is mandatory



#### Output parameter with OUT

The following stored procedure returns the number of orders by order status.
```
DROP PROCEDURE IF EXISTS GetOrderCountByStatus;

DELIMITER $$

CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END$$
DELIMITER ;
```

#### Executing the procedure and displaying the result
```
CALL GetOrderCountByStatus('Shipped',@total);
SELECT @total;
```


#### Using the INOUT parameter

In this example, the stored procedure SetCounter()  accepts one INOUT  parameter ( counter ) and one IN parameter ( inc ). It increases the counter ( counter ) by the value of specified by the inc parameter.

```
DROP PROCEDURE IF EXISTS SetCounter;

DELIMITER $$

CREATE PROCEDURE SetCounter(
	INOUT counter INT,
    	IN inc INT
)
BEGIN
	SET counter = counter + inc;
END$$
DELIMITER ;
```

#### Initializing the input parameter and repeating the execution and displaying result several times
```
SET @counter = 1;
CALL SetCounter(@counter,1); 
SELECT @counter;
CALL SetCounter(@counter,1); 
SELECT @counter;
CALL SetCounter(counter,1); 
SELECT @counter;
```

<br/><br/><br/>
<a name="if"/>
## Example with IF and declaring variables

The IF syntax can have different forms:
* IF-THEN
* IF-THEN-ELSE
* IF-THEN-ELSEIF-ELSE 

Assigning Customer Level based on credit. Mind the usage of credit variable used the procedure. 

```
DROP PROCEDURE IF EXISTS GetCustomerLevel;

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    	IN  pCustomerNumber INT, 
    	OUT pCustomerLevel  VARCHAR(20)
)
BEGIN
	DECLARE credit DECIMAL DEFAULT 0;

	SELECT creditLimit 
		INTO credit
			FROM customers
				WHERE customerNumber = pCustomerNumber;

	IF credit > 50000 THEN
		SET pCustomerLevel = 'PLATINUM';
	ELSE
		SET pCustomerLevel = 'NOT PLATINUM';
	END IF;
END$$
DELIMITER ;

```

#### Execution for a specific customer

Calling the stored procedure for customer number 447  and show the value of the OUT parameter pCustomerLevel:
```
CALL GetCustomerLevel(447, @level);
SELECT @level;
```

Note: CASE instruction is also available. We will skip CASE because you can do the same with IF. Sometimes CASE looks nicer or might be even faster for the interpreter. 


<br/><br/><br/>
<a name="loops"/>
# Iterating with LOOP

Basic loop counting to 5 and display it:

```
DROP PROCEDURE IF EXISTS LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT;
    
	SET x = 0;
        
	myloop: LOOP 
	           
		SET  x = x + 1;
    		SELECT x;
           
		IF  (x = 5) THEN
			LEAVE myloop;
         	END  IF;
         
	END LOOP myloop;
END$$
DELIMITER ;
```
#### Execution and tweaks:
`CALL LoopDemo();`

Displaying with SELECT is not ideal if you have a long loop. You better create a simple log table named "messages" and write your logs into it:

`CREATE TABLE messages (message varchar(100) NOT NULL);`

and add the next line instead of `SELECT x;`:

`INSERT INTO messages SELECT CONCAT('x:',x);`

also add `TRUNCATE messages;` before the loop.

Note: You can you other interating commands instead of LOOP, such as WHILE, REPEAT, but similarly to IF/CASE, with the LOOP you can cover every case. 


<br/><br/><br/>
<a name="cursor"/>
## Iterating trough a table with CURSOR

#### Fixing US phones in customer table 
The aim of the next snippet is to add the international prefix to US domestic format.

These are the possible formats in US:
* 754-3010 Local
* (541) 754-3010 Domestic
* +1-541-754-3010 International
* 1-541-754-3010 Dialed in the US

```
DROP PROCEDURE IF EXISTS FixUSPhones; 

DELIMITER $$

CREATE PROCEDURE FixUSPhones ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE phone varchar(50) DEFAULT "x";
	DECLARE customerNumber INT DEFAULT 0;
    	DECLARE country varchar(50) DEFAULT "";

	-- declare cursor for customer
	DECLARE curPhone
		CURSOR FOR 
            SELECT customers.customerNumber, customers.phone, customers.country FROM classicmodels.customers;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPhone;
    
    	-- create a copy of the customer table 
	DROP TABLE IF EXISTS classicmodels.fixed_customers;
	CREATE TABLE classicmodels.fixed_customers LIKE classicmodels.customers;
	INSERT fixed_customers SELECT * FROM classicmodels.customers;

	fixPhone: LOOP
		FETCH curPhone INTO customerNumber,phone, country;
		IF finished = 1 THEN 
			LEAVE fixPhone;
		END IF;
		 
		-- insert into messages select concat('country is: ', country, ' and phone is: ', phone);
         
		IF country = 'USA'  THEN
			IF phone NOT LIKE '+%' THEN
				IF LENGTH(phone) = 10 THEN 
					SET  phone = CONCAT('+1',phone);
					UPDATE classicmodels.fixed_customers 
						SET fixed_customers.phone=phone 
							WHERE fixed_customers.customerNumber = customerNumber;
                		END IF;    
			END IF;
       		 END IF;

	END LOOP fixPhone;
	CLOSE curPhone;

END$$
DELIMITER ;
```

Execute the procedure:
`CALL FixUSPhones();`

Check the resulted new table:
`SELECT * FROM fixed_customers where country = 'USA';`


<br/><br/><br/>
<a name="advantages"/>
# Advantages/disadvantages of stored procedures

#### Advantages
* Embedded processing, no need to extract data to process it with an external procedural language or tool - this is potentially faster and reduces network traffic
* Maintainable code, avoiding duplicates
* Better security, better control over data access

#### Disadvantages
* Impact over server resources (CPU, memory)
* Debugging / Trouble shooting  is not the most advanced
* Overall the business logic written in stored procedures can be written easier/nicer in other languages 



<br/><br/><br/>
<a name="homework"/>
# Homework

Continue the last script: complete the US local phones to international using the city code. Hint: for this you need to find a data source with domestic prefixes mapped to cities, import as a table to the database and add new business logic to the procedure.






