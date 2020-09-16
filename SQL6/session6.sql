
DROP TABLE IF EXISTS order_store;

CREATE TABLE order_store AS
SELECT 
   *
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
    

DROP TRIGGER IF EXISTS after_order_insert; 

DELIMITER $$

CREATE TRIGGER after_orderdetails_insert
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
  
	-- empty log table
	TRUNCATE messages;

	-- log the order number of the newley inserted order
    INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

	-- archive the order and assosiated table entries to order_store
  	INSERT INTO order_store
	SELECT 
	   *
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



SELECT * FROM classicmodels.order_store;

SELECT COUNT(*) FROM classicmodels.order_store;

INSERT INTO orders  VALUES(16,'2020-10-01','2020-10-01','2020-10-01','Shipped','CEU',131);
INSERT INTO orderdetails  VALUES(16,'S18_1749','1','10',1);

SELECT * FROM classicmodels.order_store WHERE comments = 'CEU';

SELECT * FROM classicmodels.messages;

truncate classicmodels.messages;


DROP VIEW IF EXISTS USA;

CREATE VIEW `USA` AS
SELECT * FROM classicmodels.order_store WHERE country = 'USA';


DROP VIEW IF EXISTS Year_2004;

CREATE VIEW `Year_2004` AS
SELECT * FROM classicmodels.order_store WHERE orderDate LIKE '2004%';

