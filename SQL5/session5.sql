
USE classicmodels;

-- basic
DROP PROCEDURE IF EXISTS GetAllProducts;


DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT *  FROM products;
    SELECT *  FROM orders;
END //

DELIMITER ;


CALL GetAllProducts();




-- IN
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

CALL GetOfficeByCountry('USA'); 
CALL GetOfficeByCountry('France'); 
CALL GetOfficeByCountry();

-- Exercise1: Create a stored procedure which displays the first X entries of payment table. X is IN parameter for the procedure.

-- OUT

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

CALL GetOrderCountByStatus('Shipped',@total);

CALL anotherProc(@total);
SELECT @total;


-- Exercise2: Create a stored procedure which returns the amount for Xth entry of payment table. X is IN parameter for the procedure. Display the returned amount.


-- INOUT

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

SET @counter = 1;
CALL SetCounter(@counter,1); 
SELECT @counter;
CALL SetCounter(@counter,1); 
SELECT @counter;
CALL SetCounter(@counter,-1); 
SELECT @counter;

-- IF

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

CALL GetCustomerLevel(447, @level);
SELECT @level;

-- Exercise3:  Create a stored procedure which returns category of a given row. Row number is IN parameter, while category is OUT parameter. Display the returned category. CAT1 - amount > 100.000, CAT2 - amount > 10.000, CAT3 - amount <= 10.000

-- LOOP

USE classicmodels;

DROP PROCEDURE IF EXISTS LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
      
	myloop: LOOP 
		SELECT * FROM offices;
	END LOOP myloop;
    
END$$
DELIMITER ;

CALL LoopDemo();

-- LEAVE myloop;

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

CALL LoopDemo();


-- debug


CREATE TABLE IF NOT EXISTS messages (message varchar(100) NOT NULL);

DROP PROCEDURE IF EXISTS LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT;
    
	SET x = 0;
     
	TRUNCATE messages;
	myloop: LOOP 
	           
		SET  x = x + 1;
    	INSERT INTO messages SELECT CONCAT('x:',x);
           
		IF  (x = 5) THEN
			LEAVE myloop;
         	END  IF;
         
	END LOOP myloop;
END$$
DELIMITER ;

SELECT * FROM messages;

CALL LoopDemo();



-- CURSOR

DROP PROCEDURE IF EXISTS CursorDemo;

DELIMITER $$
CREATE PROCEDURE CursorDemo()
BEGIN
	
    DECLARE phone varchar(50) DEFAULT "blabla";
    DECLARE finished INTEGER DEFAULT 0;
    
    DECLARE curPhone CURSOR FOR SELECT customers.phone FROM classicmodels.customers;
        
	DECLARE CONTINUE HANDLER  FOR NOT FOUND SET finished = 1;

	OPEN curPhone;
    
	TRUNCATE messages;
	myloop: LOOP 
	           
		FETCH curPhone INTO phone;
        INSERT INTO messages SELECT CONCAT('phone:',phone);
        
		IF finished = 1 THEN LEAVE myloop;
		END IF;
         
	END LOOP myloop;
END$$
DELIMITER ;

SELECT * FROM messages;

CALL CursorDemo();

-- Exercise: Loop through orders table. Fetch orderNumber + shippedDate. Write in both fields into messages as one line.alter

-- Extra exercise: take a look at the next example with FixUSPhones on Git. Try to solve the Homework. 

CREATE TABLE new_order LIKE orders;

DROP TABLE new_order;

CREATE TABLE new_order AS SELECT * FROM orders;

-- Exercise: Create a stored procedure which creates a table called "product_sales" using the select from HW4.



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

	TRUNCATE messages;
    
	fixPhone: LOOP
		FETCH curPhone INTO customerNumber,phone, country;
		IF finished = 1 THEN 
			LEAVE fixPhone;
		END IF;
		 
		INSERT INTO messages SELECT CONCAT('country is: ', country, ' and phone is: ', phone);
         
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

CALL FixUSPhones();

SELECT * FROM fixed_customers WHERE country = 'USA';

SELECT * FROM messages;








