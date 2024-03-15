EXEC addToTables 'TestTable1'

CREATE OR ALTER VIEW TestView1 AS
    SELECT *
    FROM TestTable1
    WHERE ID > 5;

EXEC addToViews 'TestView1'
EXEC addToTests 'Test1'

EXEC connectTableToTest 'TestTable1', 'Test1', 10, 1;
EXEC connectViewToTest 'TestView1', 'Test1';

ALTER TABLE TestTable2 NOCHECK CONSTRAINT ALL;
CLOSE tableCursor;
DEALLOCATE tableCursor;
close viewCursor;
deallocate viewCursor;

create or alter procedure populateTableTestTable1 (@rows int) as
    while @rows > 0 begin
        insert into TestTable1 (ID, Name) VALUES (@rows, 'Test' + cast(@rows as varchar(10)));
        set @rows = @rows-1
    end

GO
EXEC runTest 'Test1';
