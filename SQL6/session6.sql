
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
    



-- empty log table
TRUNCATE messages;
    
    
DROP TRIGGER IF EXISTS after_order_insert; 

DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
   
	-- log the order number of the newley inserted order
    INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

   
	-- archive the order and assosiated table entries to order_store
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



SELECT * FROM product_sales ORDER BY SalesId;

SELECT COUNT(*) FROM product_sales;

INSERT INTO orders  VALUES(16,'2020-10-01','2020-10-01','2020-10-01','Done','',131);
INSERT INTO orderdetails  VALUES(16,'S18_1749','1','10',1);

SELECT * FROM messages;

SELECT * FROM product_sales WHERE product_sales.SalesId = 16;





DROP VIEW IF EXISTS USA;

CREATE VIEW `USA` AS
SELECT * FROM product_sales WHERE country = 'USA';


DROP VIEW IF EXISTS Year_2004;

CREATE VIEW `Year_2004` AS
SELECT * FROM product_sales WHERE product_sales.Date LIKE '2004%';

DROP VIEW IF EXISTS Vintage_Cars;

CREATE VIEW `Vintage_Cars` AS
SELECT * FROM product_sales WHERE product_sales.Brand = 'Vintage Cars';



