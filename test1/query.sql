CREATE TABLE Countries(
    countryId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    population INT NOT NULL,
    foundingYear YEAR NOT NULL,
    CONSTRAINT foundingYear CHECK (foundingYear < 2023),
    gdpMillions DECIMAL(10,2) NOT NULL,
    capitalId INT NOT NULL
);

CREATE TABLE Counties(
    countyId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    population INT NOT NULL,
    countryId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES Countries(countryId)
);

CREATE TABLE Cities(
    cityId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    population INT NOT NULL,
    countyId INT,
    FOREIGN KEY (countyId) REFERENCES Counties(countyId)
);



CREATE TABLE CountryRegion(
    countryRegionId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    population INT,
    countryId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES Countries(countryId)
);

CREATE TABLE CountyPartOfRegion(
    countyId INT NOT NULL,
    countryRegionId INT NOT NULL,
    PRIMARY KEY (countyId, countryRegionId),
    FOREIGN KEY (countyId) REFERENCES Counties(countyId),
    FOREIGN KEY (countryRegionId) REFERENCES CountryRegion(countryRegionId)
);

CREATE TABLE ContinentalRegion(
    continentalRegionId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    population INT
);

CREATE TABLE CountryPartOfRegion(
    countryId INT NOT NULL,
    continentalRegionId INT NOT NULL,
    PRIMARY KEY (countryId, continentalRegionId),
    FOREIGN KEY (countryId) REFERENCES Countries(countryId),
    FOREIGN KEY (continentalRegionId) REFERENCES ContinentalRegion(continentalRegionId)
);

CREATE TABLE EuropeanInstitution(
    institutionId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    description VARCHAR(100) NOT NULL,
    numberCountries INT
);

CREATE TABLE CountryPartOfInstitution(
    countryId INT NOT NULL,
    institutionId INT NOT NULL,
    PRIMARY KEY (countryId, institutionId),
    FOREIGN KEY (countryId) REFERENCES Countries(countryId),
    FOREIGN KEY (institutionId) REFERENCES EuropeanInstitution(institutionId)
);

CREATE TABLE PoliticalParties(
    partyId INT PRIMARY KEY AUTO_INCREMENT,
    fullName VARCHAR(40) NOT NULL,
    abbreviation VARCHAR(10) NOT NULL,
    description VARCHAR(100),
    alignment VARCHAR(15) NOT NULL,
    numberMembers INT NOT NULL,
    countryId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES Countries(countryId)
);

ALTER TABLE Countries
    ADD FOREIGN KEY (capitalId) REFERENCES Cities(cityId);

ALTER TABLE Countries
    ALTER COLUMN capitalId SET DEFAULT -1;

ALTER TABLE Cities
    ALTER COLUMN countyId SET DEFAULT -1;

ALTER TABLE Countries
    MODIFY COLUMN capitalId INT NULL;

ALTER TABLE Countries
    RENAME COLUMN gdpMillions TO gdpTrillions;

ALTER TABLE Countries
    MODIFY COLUMN foundingYear INT NULL;

ALTER TABLE Countries
    DROP CONSTRAINT foundingYear,
    ADD CONSTRAINT foundingYear CHECK (foundingYear < 2023 AND foundingYear > 0);

RENAME TABLE CountryRegion TO CountryRegions;

RENAME TABLE ContinentalRegion TO ContinentalRegions;

RENAME TABLE EuropeanInstitution TO EuropeanInstitutions;

ALTER TABLE Counties
    COMMENT 'Or states';

ALTER TABLE Counties
    MODIFY COLUMN name VARCHAR(35) NOT NULL;

ALTER TABLE CountryRegions
    MODIFY COLUMN name VARCHAR(35) NOT NULL;