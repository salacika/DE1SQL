
-- INNER
SELECT * 
FROM products 
INNER JOIN productlines  
ON products.productline = productlines.productline;


SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;


SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
USING(productline);


-- SELF

SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
    

-- LEFT
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber;
    
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
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;

