DELIMITER ;

CREATE PROCEDURE change_name_party_to_char()
BEGIN
    ALTER TABLE PoliticalParties
        MODIFY COLUMN fullName CHAR(50);
END;

CREATE PROCEDURE change_name_party_to_varchar()
BEGIN
    ALTER TABLE PoliticalParties
        MODIFY COLUMN fullName VARCHAR(50);
END;

CREATE PROCEDURE drop_number_of_members()
BEGIN
    ALTER TABLE PoliticalParties
        DROP COLUMN numberMembers;
END;

CREATE PROCEDURE add_number_of_members()
BEGIN
    ALTER TABLE PoliticalParties
        ADD COLUMN numberMembers INT;
END;

CREATE PROCEDURE default_number_members_0()
BEGIN
    ALTER TABLE PoliticalParties
        ALTER COLUMN numberMembers SET DEFAULT 0;
END;

CREATE PROCEDURE number_members_remove_default()
BEGIN
    ALTER TABLE PoliticalParties
        ALTER COLUMN numberMembers DROP DEFAULT;
END;

DROP PROCEDURE IF EXISTS remove_primary_key;

CREATE PROCEDURE remove_primary_key()
BEGIN
    ALTER TABLE PoliticalParties
        MODIFY COLUMN partyId INT NOT NULL;
    ALTER TABLE PoliticalParties
        DROP PRIMARY KEY ;
END;

DROP PROCEDURE IF EXISTS add_primary_key;

CREATE PROCEDURE add_primary_key()
BEGIN
    ALTER TABLE PoliticalParties
        ADD PRIMARY KEY (partyId);
    ALTER TABLE PoliticalParties
        MODIFY COLUMN partyId INT NOT NULL AUTO_INCREMENT;
END;

CREATE PROCEDURE make_name_key()
BEGIN
    ALTER TABLE PoliticalParties
        ADD UNIQUE (fullName);
END;

CALL make_name_key();

CREATE PROCEDURE remove_name_key()
BEGIN
    ALTER TABLE PoliticalParties
        DROP INDEX fullName;
END;

CALL remove_name_key();

DROP PROCEDURE IF EXISTS remove_foreign_key;

CREATE PROCEDURE remove_foreign_key()
BEGIN
    ALTER TABLE PoliticalParties
        DROP FOREIGN KEY PoliticalParties_ibfk_1;
END;

CREATE PROCEDURE add_foreign_key()
BEGIN
    ALTER TABLE PoliticalParties
        ADD FOREIGN KEY (countryId) REFERENCES Countries(countryId);
END;

CREATE PROCEDURE create_table()
BEGIN
    CREATE TABLE KebabShops (
        kebabShopId INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(50) NOT NULL,
        address VARCHAR(50) NOT NULL,
        PRIMARY KEY (kebabShopId)
    );
end;

CALL create_table();

CREATE PROCEDURE drop_table()
BEGIN
    DROP TABLE KebabShops;
END;

CALL drop_table();

CREATE TABLE VersionTable(
    version INT NOT NULL
);

DELETE FROM VersionTable WHERE version IS NOT NULL;

INSERT INTO VersionTable (version) VALUES (1);

CREATE TABLE ProceduresTable(
    fromVersion INT NOT NULL,
    toVersion INT NOT NULL,
    procedureName VARCHAR(50) NOT NULL,
    PRIMARY KEY (fromVersion, toVersion)
);

call change_name_party_to_char();
call change_name_party_to_varchar();
call drop_number_of_members();
call add_number_of_members();
call default_number_members_0();
call number_members_remove_default();
call remove_primary_key();
call add_primary_key();
call make_name_key();
call remove_name_key();
call remove_foreign_key();
call add_foreign_key();
call create_table();
call drop_table();


INSERT INTO ProceduresTable (fromVersion, toVersion, procedureName) VALUES
    (1, 2, 'change_name_party_to_char'),
    (2, 1, 'change_name_party_to_varchar'),
    (2, 3, 'drop_number_of_members'),
    (3, 2, 'add_number_of_members'),
    (3, 4, 'default_number_members_0'),
    (4, 3, 'number_members_remove_default'),
    (4, 5, 'remove_primary_key'),
    (5, 4, 'add_primary_key'),
    (5, 6, 'make_name_key'),
    (6, 5, 'remove_name_key'),
    (6, 7, 'remove_foreign_key'),
    (7, 6, 'add_foreign_key');

DELETE FROM ProceduresTable WHERE fromVersion IS NOT NULL AND toVersion IS NOT NULL;

DROP PROCEDURE IF EXISTS goToVersion;

CREATE PROCEDURE goToVersion(target INT)
BEGIN
    DECLARE currentVersion INT;
    DECLARE procedureN VARCHAR(50);
    SELECT version INTO currentVersion FROM VersionTable;
    IF target > (SELECT MAX(toVersion) FROM ProceduresTable) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Target version does not exist';
    END IF;
    DELETE FROM VersionTable WHERE version IS NOT NULL;
    WHILE currentVersion < target DO
        SELECT procedureName INTO procedureN FROM ProceduresTable WHERE fromVersion = currentVersion AND toVersion = currentVersion + 1;
        SET @s = CONCAT('CALL ', procedureN, '()');
        SELECT @s;
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET currentVersion = currentVersion + 1;
    END WHILE;
    WHILE currentVersion > target DO
        SELECT procedureName INTO procedureN FROM ProceduresTable WHERE fromVersion = currentVersion AND toVersion = currentVersion - 1;
        SET @s = CONCAT('CALL ', procedureN, '()');
        SELECT @s as currentVersion;
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET currentVersion = currentVersion - 1;
    END WHILE;
    INSERT INTO VersionTable (version) VALUES (target);
END;


CALL goToVersion(7);