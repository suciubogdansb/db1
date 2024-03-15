-- 1. Table with a single-column primary key and no foreign keys
CREATE TABLE TestTable1 (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

-- 2. Table with a single-column primary key and at least one foreign key
CREATE TABLE TestTable2 (
    ID INT PRIMARY KEY,
    TestTable1ID INT,
    Description NVARCHAR(200),
    FOREIGN KEY (TestTable1ID) REFERENCES TestTable1(ID)
);

-- 3. Table with a multicolumn primary key
CREATE TABLE TestTable3 (
    ID1 INT,
    ID2 INT,
    Value NVARCHAR(100),
    PRIMARY KEY (ID1, ID2)
);

ALTER TABLE TestTable3
    ADD CONSTRAINT FK_TestTable3_TestTable1_ID1 FOREIGN KEY (ID1) REFERENCES TestTable1(ID);


INSERT INTO TestTable1 VALUES (1, 'Test 1');
INSERT INTO TestTable1 VALUES (2, 'Test 2');
INSERT INTO TestTable1 VALUES (3, 'Test 3');
INSERT INTO TestTable1 VALUES (4, 'Test 4');
INSERT INTO TestTable1 VALUES (5, 'Test 5');
INSERT INTO TestTable1 VALUES (6, 'Test 6');
INSERT INTO TestTable1 VALUES (7, 'Test 7');
INSERT INTO TestTable1 VALUES (8, 'Test 8');
INSERT INTO TestTable1 VALUES (9, 'Test 9');
INSERT INTO TestTable1 VALUES (10, 'Test 10');

INSERT INTO TestTable2 VALUES (1, 1, 'Test2 1');
INSERT INTO TestTable2 VALUES (2, 2, 'Test2 2');
INSERT INTO TestTable2 VALUES (3, 3, 'Test2 3');
INSERT INTO TestTable2 VALUES (4, 3, 'Test2 4');
INSERT INTO TestTable2 VALUES (5, 4, 'Test2 5');
INSERT INTO TestTable2 VALUES (6, 4, 'Test2 6');
INSERT INTO TestTable2 VALUES (7, 3, 'Test2 7');
INSERT INTO TestTable2 VALUES (8, 2, 'Test2 8');
INSERT INTO TestTable2 VALUES (9, 1, 'Test2 9');
INSERT INTO TestTable2 VALUES (10, 9, 'Test2 10');

INSERT INTO TestTable3 VALUES (1, 1, 'Test3 1');
INSERT INTO TestTable3 VALUES (1, 2, 'Test3 2');
INSERT INTO TestTable3 VALUES (1, 3, 'Test3 3');
INSERT INTO TestTable3 VALUES (1, 4, 'Test3 4');
INSERT INTO TestTable3 VALUES (2, 5, 'Test3 5');
INSERT INTO TestTable3 VALUES (2, 3, 'Test3 6');
INSERT INTO TestTable3 VALUES (2, 2, 'Test3 7');
INSERT INTO TestTable3 VALUES (2, 1, 'Test3 8');
INSERT INTO TestTable3 VALUES (3, 1, 'Test3 9');
INSERT INTO TestTable3 VALUES (3, 2, 'Test3 10');





