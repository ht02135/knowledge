
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql

EXCEPT
Returns any distinct values from the query to the left of the EXCEPT operator that are not also returned from the right query.

INTERSECT
Returns any distinct values that are returned by both the query on the left and right sides of the INTERSECT operator.

////////////////

-- Uses AdventureWorks  

SELECT ProductID   
FROM Production.Product ;  
--Result: 504 Rows  

////////////////

The following query returns any distinct values that are returned by both the query on the left and right sides of the INTERSECT operator.

-- Uses AdventureWorks  

SELECT ProductID   
FROM Production.Product  
INTERSECT  
SELECT ProductID   
FROM Production.WorkOrder ;  
--Result: 238 Rows (products that have work orders)  

///////////////

The following query returns any distinct values from the query to the left of the EXCEPT operator that are not also found on the right query.

-- Uses AdventureWorks  

SELECT ProductID   
FROM Production.Product  
EXCEPT  
SELECT ProductID   
FROM Production.WorkOrder ;  
--Result: 266 Rows (products without work orders)  

///////////

