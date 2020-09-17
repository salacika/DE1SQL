-- EX1
SELECT * 
FROM orders 
INNER JOIN orderdetails 
ON orders.orderNumber = orderdetails.orderNumber;


-- EX2
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) totalsales
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;



-- EX3
SELECT orderDate,lastName, firstName
FROM orders t1
INNER JOIN customers t2
USING (customerNumber)
INNER JOIN employees t3
ON t2.salesRepEmployeeNumber = t3.employeeNumber;