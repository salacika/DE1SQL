
-- EX1
DROP PROCEDURE IF EXISTS GetFirstXPayments;

DELIMITER //

CREATE PROCEDURE GetFirstXPayments(
	IN x INT
)
BEGIN
	SELECT * 
 		FROM payments
			LIMIT x;
END //
DELIMITER ;

CALL GetFirstXPayments(18);






-- EX2
DROP PROCEDURE IF EXISTS GetAmountForXthPayments;

DELIMITER //

CREATE PROCEDURE GetAmountForXthPayments(
	IN x INT,
    OUT amountout DECIMAL(10,2)
)

BEGIN

	SET x = x-1;
    
	SELECT amount 
		INTO amountout
			FROM payments
				LIMIT x,1;
END //
DELIMITER ;

CALL GetAmountForXthPayments(4,@amount);
SELECT @amount;



-- EX3
DROP PROCEDURE IF EXISTS GetCategoryOfXthPayments;

DELIMITER //

CREATE PROCEDURE GetCategoryOfXthPayments(
	IN x INT,
    OUT category VARCHAR(10)
)

BEGIN

	DECLARE xthamount DECIMAL(10,2) DEFAULT 0;
    
	SET x = x-1;
    
	SELECT amount 
		INTO xthamount
			FROM payments
				LIMIT x,1;
		         
	IF xthamount > 100000 THEN
		SET category = 'CAT1';
	ELSEIF xthamount > 10000  THEN
		SET category = 'CAT2';
	ELSE 
		SET category = 'CAT3';
	END IF;
            
END //
DELIMITER ;

CALL GetCategoryOfXthPayments(18,@category);
SELECT @category;



