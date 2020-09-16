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
#### We want to how the emplyoees are performing. Join orders, customers and employees and return orderDate,lastName, firstName

<br/><br/>

## SELF JOIN

Employee table represents a hierarhy, which can be flantend with a self join. The next query displays the Manager, Direct report pairs:

```
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
```

### `Exercise4` 
#### Why President is not in the list?

<br>

## LEFT JOIN

The next example returns customer info and related orders:

```
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber;
```

#### Difference between LEFT and INNER join
The previous example returns all customers including the customers who have no order. If a customer has no order, the values in the column orderNumber and status are NULL. Try the same query with INNER join.

#### Difference between LEFT and RIGHT join
Right join is the mirror of the left join, you can achive the same results with both. Rarely used.

#### WHERE with joins
```
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;
```

#### ON 

In the next query, the WHERE clause is added to ON, yet, it will have a different meaning. In this case, the query returns all orders but only the order 10123 will have line items associated with it as in the following picture:
```
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;
```


<br/><br/><br/>
<a name="homework"/>
# Homework
INNER join orders,orderdetails,products and customers. Return back: orderNumber,priceEach,quantityOrdered,productName,productLine,city,country,orderDate

