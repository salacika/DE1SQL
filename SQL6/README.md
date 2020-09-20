# Chapter 6 - Overview

**Teaching**: 90 min

**Problem statement**
1. As analyst, you would like to create a dedicated analytical data layer for your analytics. How would you do that?

**Objectives**
* Understanding the difference between Operational and Analytical data layer
* Introducing Data Warehouse architectures
* Building a denormalized analytical data store 
* Building an ETL pipeline using MySQL Triggers 
* Building data marts with MySQL View



<br/><br/><br/>

# Table Content:
[Session setup](#setup)

[Creating the analytical data store](#dw)

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

We will use a query created in Homework 3. This creates a denormalized snapshot of the operational tables for product_sales subject. 

```
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
```

<br/><br/><br/>
<a name="etl"/>
## Trigger as ETL

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

View of sales in USA:
```
DROP VIEW IF EXISTS USA;

CREATE VIEW `USA` AS
SELECT * FROM product_sales WHERE country = 'USA';
```

View of sales in 2004:
```
DROP VIEW IF EXISTS Year_2004;

CREATE VIEW `Year_2004` AS
SELECT * FROM product_sales WHERE product_sales.Date LIKE '2004%';
```

View of sales for a specific brand (Vintage_Cars)
```
DROP VIEW IF EXISTS Vintage_Cars;

CREATE VIEW `Vintage_Cars` AS
SELECT * FROM product_sales WHERE product_sales.Brand = 'Vintage Cars';
```

`Note` the content of Views are generated on-the-fly. For performance reasons, in analytics, so called materialized views are preferred on large data set. This is not supported by MySQL, but there are several ways to implemented. Here is an example: https://fromdual.com/mysql-materialized-views




<br/><br/><br/>
<a name="homework"/>
# Term project








