EXEC addToTables 'TestTable3';

CREATE OR ALTER VIEW TestView3 AS
    SELECT TOP 100 COUNT(T3.ID2) as F, T.ID
    FROM TestTable3 T3 INNER JOIN TestTable1 T on T.ID = T3.ID1
    GROUP BY T.ID
    ORDER BY COUNT(T3.ID2) DESC;

EXEC addToViews 'TestView3';

EXEC addToTests 'Test3';

EXEC connectTableToTest 'TestTable1', 'Test3', 400, 1;

EXEC connectTableToTest 'TestTable3', 'Test3', 1600, 2;

EXEC connectViewToTest 'TestView3', 'Test3';

ALTER TABLE TestTable3 NOCHECK CONSTRAINT ALL;

CREATE OR ALTER PROCEDURE populateTableTestTable3 (@rows INT) as
BEGIN
    DECLARE @i INT = 0;
    DECLARE @maxT1 INT;
    SELECT @maxT1 = MAX(ID) FROM TestTable1;
    WHILE @i < @rows
    BEGIN
        INSERT INTO TestTable3(ID1, ID2, Value) VALUES (FLOOR(@maxT1*RAND()), @i, 'Test3 ' + CAST(@i AS VARCHAR(10)))
        SET @i = @i + 1;
    END
END;

EXEC runTest 'Test3';



