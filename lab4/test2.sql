EXEC addToTables 'TestTable2';

CREATE OR ALTER VIEW TestView2
AS
    SELECT T1.name, T2.Description, T2.ID
    FROM TestTable1 T1 INNER JOIN TestTable2 T2 on T1.ID = T2.TestTable1ID
    WHERE (T1.ID % 7) % 2 = 1 ;

EXEC addToViews 'TestView2';

EXEC addToTests 'Test2';

EXEC connectTableToTest 'TestTable1', 'Test2', 200, 1;
EXEC connectTableToTest 'TestTable2', 'Test2', 400, 2;

EXEC connectViewToTest 'TestView2', 'Test2';

CREATE OR ALTER PROCEDURE populateTableTestTable2 (@rows INT) AS
BEGIN
    DECLARE @maxT1 INT
    SELECT @maxT1 = MAX(ID) FROM TestTable1;
    DECLARE @i INT = 0;
    WHILE @i < @rows
    BEGIN
        INSERT INTO TestTable2 (ID, TestTable1ID, Description) VALUES (@i, FLOOR(@maxT1*RAND()), 'Test ' + CAST(@i AS VARCHAR(10)));
        SET @i = @i + 1;
    END
END;

EXEC runTest 'Test2';


