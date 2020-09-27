
-- INNER
SELECT * 
FROM products 
INNER JOIN productlines  
ON products.productline = productlines.productline;

-- aliasing
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;

-- using
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
USING(productline);

-- specific columns
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;

-- Exercise1: Join all fields of order and orderdetails

-- Exercise2: Join all fields of order and orderdetails. Display only orderNumber, status and sum of totalsales (quantityOrdered * priceEach) for each orderNumber.

-- Exercise3: We want to how the employees are performing. Join orders, customers and employees and return orderDate,lastName, firstName



-- SELF

-- Employee table represents a hierarchy, which can be flattened with a self join. The next query displays the Manager, Direct report pairs:
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
    
-- Exercise4: Why President is not in the list?


-- LEFT

-- returns customer info and related orders:
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber;
    
-- compare with INNER join. See count on INNER and LEFT JOIN:    
SELECT
  COUNT(*)
FROM
    customers c
INNER JOIN orders o 
    ON c.customerNumber = o.customerNumber;    

-- difference between LEFT and INNER join: The previous example returns all customers including the customers who have no order. If a customer has no order, the values in the column orderNumber and status are NULL. 

    
-- WHERE 
    
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
    
-- ON

-- different meaning, join will be applied only for orderNumber 10123
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;

