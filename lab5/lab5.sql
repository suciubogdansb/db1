CREATE TABLE TA (
    aid INT PRIMARY KEY,
    a2 INT UNIQUE,
    x INT,
);

EXEC sp_helpindex 'TA';

CREATE TABLE TB (
    bid INT PRIMARY KEY,
    b2 INT ,
    y INT,
);

sp_helpindex 'TB';

CREATE TABLE TC (
    cid INT PRIMARY KEY,
    aid INT FOREIGN KEY REFERENCES TA(aid),
    bid INT FOREIGN KEY REFERENCES TB(bid),
);

sp_helpindex 'TC';

CREATE OR ALTER PROCEDURE insertTA AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= 4000
    BEGIN
        INSERT INTO TA VALUES (@i, @i*2, FLOOR(RAND() * @i));
        SET @i = @i + 1;
    END
END

CREATE OR ALTER PROCEDURE insertTB AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= 3000
    BEGIN
        INSERT INTO TB VALUES (@i, FLOOR(RAND() * @i), FLOOR(RAND() * (@i * 3)));
        SET @i = @i + 1;
    END
END

EXEC insertTA;
EXEC insertTB;

CREATE OR ALTER PROCEDURE insertTC AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= 5000
    BEGIN
        INSERT INTO TC VALUES (
            @i,
            FLOOR(RAND() * 4000) + 1,
            FLOOR(RAND() * 3000) + 1
        );
        SET @i = @i + 1;
    END
END;

EXEC insertTC;

-- clustered index scan
SELECT * FROM TA ORDER BY aid;
-- noclustered index scan
SELECT a2 FROM TA ORDER BY a2;
-- clustered index seek
SELECT * FROM TA WHERE aid = 1;
-- noclustered index seek
SELECT a2 FROM TA WHERE a2 = 500;
-- key lookup + ncl index seek
SELECT x FROM TA WHERE a2 = 500;


-- cl index scan = 0.011
SELECT * FROM TB WHERE b2 > 200;

CREATE INDEX index1 ON TB (b2) INCLUDE (bid, y);

DROP INDEX index1 ON TB;

-- ncl index seek = 0.009
SELECT * FROM TB WHERE b2 > 200;

CREATE OR ALTER VIEW vw AS
    SELECT T1.x, T2.y
    FROM TA T1 INNER JOIN TC T on T1.aid = T.aid INNER JOIN TB T2 on T.bid = T2.bid
    WHERE T1.x > 1000 AND T2.y > 1000;


-- no index = 0.198
SELECT * FROM vw;

CREATE INDEX index2 ON TA (x) INCLUDE (aid);
CREATE INDEX index3 ON TB (y) INCLUDE (bid);
CREATE INDEX index4 ON TC (aid, bid);

DROP INDEX index2 ON TA;
DROP INDEX index3 ON TB;
DROP INDEX index4 ON TC;

-- with index = 0.182
SELECT * FROM vw;



