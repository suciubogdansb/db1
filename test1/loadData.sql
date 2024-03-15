-- Insert data about 6 countries from Europe in the table "Countries"
INSERT INTO eurocountries.Countries (name, population, foundingYear, gdpTrillions) VALUES
('Germany', 83000000, 1866, 4.26),
('France', 67000000, 1792, 2.95),
('Italy', 60000000, 1946, 2.1),
('Spain', 47000000, 1978, 1.4),
('Poland', 38000000, 1791, 1.2),
('Romania', 19000000, 1859, 0.28);

-- Insert data about 5 counties from Romania in the table "Counties" (not the capital)
INSERT INTO Counties(name, population, countryId) VALUES
('Cluj', 700000, 6),
('Timis', 700000, 6),
('Constanta', 600000, 6),
('Iasi', 500000, 6),
('Maramures', 400000, 6);

-- Insert data about 5 cities from Romania in the table "Cities" (not the capital)
INSERT INTO Cities(name, population, countyId) VALUES
('Cluj-Napoca', 300000, 1),
('Timisoara', 300000, 2),
('Constanta', 300000, 3),
('Iasi', 300000, 4),
('Baia Mare', 300000, 5);

INSERT INTO Cities(name, population) VALUES
('Bucharest', 2000000);

-- Insert data about Bucharest in the table "Cities"
INSERT INTO Cities(name, population, countyId) VALUES
('Bucharest', 2000000, NULL);

-- Insert data about 5 counties from Germany in the table "Counties" (not the capital)
INSERT INTO Counties(name, population, countryId) VALUES
('Hamburg', 2000000, 1),
('Munich', 1500000, 1),
('Cologne', 1000000, 1),
('Frankfurt', 700000, 1),
('Stuttgart', 600000, 1);

-- Remove the counties from Germany
DELETE FROM Counties WHERE countryId = 1;

-- Insert data about 5 states from Germany in the table "Counties"
INSERT INTO Counties(name, population, countryId) VALUES
('Hamburg', 2000000, 1),
('Bavaria', 13000000, 1),
('North Rhine-Westphalia', 18000000, 1),
('Hesse', 6000000, 1),
('Baden-Württemberg', 11000000, 1),
('Berlin', 3600000, 1);

-- Insert data about 8 cities from Germany from previously added states the in the table "Cities"
INSERT INTO Cities(name, population, countyId) VALUES
('Hamburg', 1800000, 11),
('Munich', 1500000, 12),
('Cologne', 1000000, 13),
('Frankfurt', 700000, 14),
('Stuttgart', 600000, 15),
('Berlin', 3600000, 16),
('Dortmund', 600000, 13),
('Essen', 600000, 13);

UPDATE Countries
SET capitalId = (SELECT cityId FROM Cities WHERE name = 'Bucharest')
WHERE name = 'Romania';

UPDATE Countries
SET capitalId = (SELECT cityId FROM Cities WHERE name = 'Berlin')
WHERE name = 'Germany';

-- Remove cities from the county Iasi or the state of Hesse
DELETE FROM Cities WHERE countyId IN (4, 14);

-- Remove countries with gpds between 1 and 1.5 trillion
DELETE FROM Countries WHERE gdpTrillions BETWEEN 1 AND 1.5;

UPDATE Cities
SET population = 1830000
WHERE countyId IS NULL;

-- Add the regions of Romania in table "CountryRegion"
INSERT INTO CountryRegion(name, countryId) VALUES
('Transylvania', 6),
('Moldova', 6),
('Muntenia', 6),
('Dobrogea', 6),
('Banat', 6),
('Crisana', 6),
('Maramures', 6),
('Oltenia', 6),
('Bucovina', 6);

INSERT INTO CountryRegion(name, countryId) VALUES
('Ardeal', 6),
('Valachia', 6);

-- Connect the regions of Romania with the counties in table "CountyPartOfRegion"
INSERT INTO CountyPartOfRegion(countyId, countryRegionId) VALUES
(1,1),
(2,5),
(3,4),
(4,2),
(5,6),
(5,1),
(2,1),
(1,10),
(3, 11);

UPDATE CountryRegion
SET name = 'Moldavia'
WHERE name = 'Moldova';

UPDATE Countries
SET gdpTrillions = 2.11
WHERE name LIKE '%a%' AND population < 65000000;

UPDATE Countries
SET gdpTrillions = 0.28
WHERE capitalId IN (SELECT cityId FROM Cities WHERE name = 'Bucharest');

-- Insert data about 5 provinces from France in the table "Counties"
INSERT INTO Counties(name, population, countryId) VALUES
('Île-de-France', 12000000, 2),
('Provence', 5000000, 2),
('Normandy', 3500000, 2),
('Dauphiné', 2000000, 2),
('Burgundy', 1600000, 2);

-- Delete the provinces from France
DELETE FROM Counties WHERE countryId = 2;

-- Insert data about 8 cities from France from previously added provinces the in the table "Cities"
INSERT INTO Cities(name, population, countyId) VALUES
('Paris', 2200000, 32),
('Marseille', 1600000, 33),
('Aix', 150000, 33),
('Caen', 470000, 34),
('Rouen', 700000, 34),
('Grenoble', 700000, 34),
('Vienne', 30000, 34),
('Dijon', 160000, 35);

UPDATE Cities
SET countyId = 35
WHERE Cities.name IN ('Grenoble', 'Vienne');

UPDATE Cities
SET countyId = 36
WHERE Cities.name = 'Dijon';

-- Add the regions of France in table "CountryRegion"
INSERT INTO CountryRegions(name, countryId) VALUES
('Auvergne-Rhône-Alpes', 2),
('Bourgogne-Franche-Comté',2),
('Bretagne', 2),
('Centre-Val de Loire', 2),
('Corse', 2),
('Grand Est', 2),
('Hauts-de-France', 2),
('Île-de-France', 2),
('Normandie', 2),
('Nouvelle-Aquitaine', 2),
('Occitanie', 2),
('Pays de la Loire', 2),
('Provence-Alpes-Côte d''Azur', 2);

-- Connect the regions of France with the counties in table "CountyPartOfRegion"
INSERT INTO CountyPartOfRegion(countyId, countryRegionId) VALUES
(33, 24),
(32, 19),
(34, 20),
(35, 12),
(36, 13);

UPDATE Cities
SET population = 290000
WHERE name = 'Cluj-Napoca';

UPDATE Cities
SET population = 250000
WHERE name = 'Timisoara';

UPDATE Cities
SET population = 260000
WHERE name = 'Constanta';

UPDATE Cities
SET population = 110000
WHERE name = 'Baia Mare';

UPDATE Countries
SET capitalId = (SELECT cityId FROM Cities WHERE name = 'Paris')
WHERE name = 'France';

-- Add regions of Europe in table "ContinentRegions"
INSERT INTO ContinentalRegions(name) VALUES
('Western Europe'),
('Northern Europe'),
('Southern Europe'),
('Eastern Europe'),
('Central Europe'),
('Balkans'),
('Scandinavia'),
('Baltic States'),
('Benelux'),
('Iberian Peninsula'),
('Caucasus'),
('Mediterranean');

-- Connect the regions of Europe with the countries in table "CountryPartOfRegion"
INSERT INTO CountryPartOfRegion(countryId, continentalRegionId) VALUES
    (1, 1), (1, 5), (2, 1), (3, 3), (3, 12), (6, 4), (6, 6), (6, 5);







