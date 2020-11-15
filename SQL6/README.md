# Chapter 6 - Overview

**Teaching**: 90 min

**Problem statement**
1. As analyst, you would like to create a dedicated analytical data layer for your analytics. How would you do that?

**Objectives**
* Building a denormalized analytical data store 
* Building an ETL pipeline using MySQL Triggers and Events
* Building data marts with MySQL View



<br/><br/><br/>

# Table Content:
[Session setup](#setup)

[Creating the analytical data store](#dw)

[Events to schedule ETL jobs](#jobs)

[Trigger as ETL](#etl)

[Data marts with Views](#datamart)

[Security with Views](#security)

[Term project](#homework)  


<br/><br/><br/>
<a name="setup"/>
## Session setup

Install [sample database](/SQL5/sampledatabase_create.sql?raw=true) script. Credit: https://www.mysqltutorial.org/mysql-sample-database.aspx

#### Database diagram
![Database diagram](/SQL5/sampledatabase_diagram.png)

<br/><br/><br/>
<a name="dw"/>
## Creating the analytical data store

We will use a query created in Homework 3. This creates a denormalized snapshot of the operational tables for product_sales subject. We will embed the creation in a stored procedure. 

```
DROP PROCEDURE IF EXISTS CreateProductSalesStore;

DELIMITER //

CREATE PROCEDURE CreateProductSalesStore()
BEGIN

	DROP TABLE IF EXISTS product_sales;

	CREATE TABLE product_sales AS
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,   
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	ORDER BY 
		orderNumber, 
		orderLineNumber;

END //
DELIMITER ;


CALL CreateProductSalesStore();
```

<br/><br/><br/>
<a name="jobs"/>
## Events to schedule ETL jobs

Event engine runs scheduled jobs/tasks. We can us it for scheduling ETL processes. 

Basics on how to check the state of the scheduler. Check if scheduler is running 

`SHOW VARIABLES LIKE "event_scheduler";`

Turn it on if not

`SET GLOBAL event_scheduler = ON;`

This is how you turn it OFF

`SET GLOBAL event_scheduler = OFF;`


Event which is calling CreateProductSalesStore every 1 minute in the next 1 hour. 
```
DELIMITER $$

CREATE EVENT CreateProductSalesStoreEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages SELECT CONCAT('event:',NOW());
    		CALL CreateProductSalesStore();
	END$$
DELIMITER ;
```

Listing all events stored in the schema

`SHOW EVENTS;`

Deleting an event

`DROP EVENT IF EXISTS CreateProductSalesStoreEvent;`


<br/><br/><br/>
<a name="etl"/>
## Trigger as ETL


Format:

```
DELIMITER $$

CREATE TRIGGER trigger_namex
    AFTER INSERT ON table_namex FOR EACH ROW
BEGIN
    -- statements
    -- NEW.orderNumber, NEW.productCode etc
END$$    

DELIMITER ;
```

<br/><br/>
### `Exercise1` 
### Copy the birdstrikes structure into a new tabe called birdstrikes2. Insert into birdstrikes2 the line where id is 10.
### Hints:
### Use the samples from Chapter2 for copy
### For insert use the format like: INSERT INTO bla SELECT blabla
<br/><br/>


Empty log table:

`TRUNCATE messages;`

#### The trigger
Creating a trigger which is activated if an insert is executed into orderdetails table. Once triggered will insert a new line in our previously created data store.

```
DROP TRIGGER IF EXISTS after_order_insert; 

DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
	
	-- log the order number of the newley inserted order
    	INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

	-- archive the order and assosiated table entries to product_sales
  	INSERT INTO product_sales
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	WHERE orderNumber = NEW.orderNumber
	ORDER BY 
		orderNumber, 
		orderLineNumber;
        
END $$

DELIMITER ;
```

<br>

`E` - Extract: Joining the tables for the operational layer is an extract operation

`T` - Transform: We don't have glamorous transformations here, only a WeekOfYear covering this part. Nevertheless, please note that you call a store procedure form trigger or even use procedural language to do transformation in the trigger itself. 

`L` - Load: Inserting into product_sales represents the load part of the ETL

#### Activating the trigger

Listing the current state of the product_sales. Please note that, there is no orderNumber 16.

`SELECT * FROM product_sales ORDER BY SalesId;`

Now will activate the trigger by inserting into orderdetails:
```
INSERT INTO orders  VALUES(16,'2020-10-01','2020-10-01','2020-10-01','Done','',131);
INSERT INTO orderdetails  VALUES(16,'S18_1749','1','10',1);
```

Check product_sales again, you should have orderNumber 16:
`SELECT * FROM product_sales ORDER BY SalesId;`

`Note` Triggers are not the only way to initiate an ETL process. In fact for performance reasons, it is advised to use the Event engine on large data sets. For more information check: https://www.mysqltutorial.org/mysql-triggers/working-mysql-scheduled-event/


<br/><br/><br/>
<a name="datamart"/>
# Data marts with Views

With views we can define sections of the datastore and prepare them for a BI operation such as reporting.



View of sales for a specific brand (Vintage_Cars)
```
DROP VIEW IF EXISTS Vintage_Cars;

CREATE VIEW `Vintage_Cars` AS
SELECT * FROM product_sales WHERE product_sales.Brand = 'Vintage Cars';
```


View of sales in USA:
```
DROP VIEW IF EXISTS USA;

CREATE VIEW `USA` AS
SELECT * FROM product_sales WHERE country = 'USA';
```

`Note` the content of Views are generated on-the-fly. For performance reasons, in analytics, so called materialized views are preferred on large data set. This is not supported by MySQL, but there are several ways to implemented. Here is an example: https://fromdual.com/mysql-materialized-views


<br/><br/>
### `Exercise2` 
### Create a view, which contains product_sales rows of 2003 and 2005.
<br/><br/>

<br/><br/><br/>
<a name="homework"/>
# Term project


### Goal
* Linking the bit and pieces learnt during the course, so that students can see how all these fits together
* Exercise once more the SQL statements covered in the course
* Go beyond what we learn. Depending on the scope, student choose to submit, one might need to expand the knowledge acquired during the course
* Learning the format of delivering such a project (naming, packaging, versioning, documenting, testing etc.)

### High level requirements
**OPERATIONAL LAYER:** Create an operational data layer in MySQL. Import a relational data set of your choosing into your local instance. Find a data which makes sense to be transformed in analytical data layer for further analytics. In ideal case, you can use the outcome of HW1.

**ANALYTICS:** Create a short plan of what kind of analytics can be potentially executed on this data set.  Plan how the analytical data layer, ETL, Data Mart would look like to support these analytics. (Remember ProductSales example during the class). 

**ANALYTICAL LAYER:** Design a denormalized data structure using the operational layer. Create table in MySQL for this structure. 

**ETL PIPLINE:** Create an ETL pipeline using Triggers, Stored procedures. Make sure to demonstrate every element of ETL (Extract, Transform, Load)

**DATA MART:** Create Views as data marts. 

*Optional: create Materialized Views with Events for some of the data marts. 




### Delivery
The project artifacts should be stored and handed over in a folder "Term DE1" on your GitHub repo.

I will give you the freedom of choosing naming conventions and structure, since this was not covered implicitly in the course. Yet, I would encourage you, to find some reading over the internet and whatever you choose, be consistent. 

Testing is optional, for the same reason, we have not covered during the course. Yet, be aware that this is important part of a project delivery. 
Documentation: use the possibilities offered by GIT markdown and comments in the sql files. 

Reproducibility: the project should be reproducible in a straightforward manner. In other words, I should be able to run your code and obtain the same outcome as you. 

### Grading criteria


-	Fitness of the input dataset to the purpose **5 points**
-	Complexity of the input data set **5 points**
-	Execution of the operational data layer **10 points**
-	Analytics plan **10 points**
-	Execution of the analytical data layer **10 points**
-	ETL **15 points**
-	Data Marts **10 points**
-	Delivery: Naming, structure **10 points**
-	Delivery: Documentation **10 points**
-	Reproducibility **15 points**

Extra points:
- Events / Triggers
- Testing
- Materialized Views 
- Anything special not covered during the course but, makes sense in the project context

### Submission 
Submit GitHub link to Moodle when you are ready. The deadline for the term project is 20th of November EOD.






