-- a
SELECT C.name, CR.name
FROM Countries C,
     CountryRegions CR
WHERE C.countryId = CR.countryId
  and C.name = 'France'
UNION ALL
SELECT C1.name, CR1.name
FROM Countries C1,
     CountryRegions CR1
WHERE C1.countryId = CR1.countryId
  and C1.name = 'Romania';


-- a
SELECT Countries.name, Counties.name
FROM Countries,
     Counties
WHERE Countries.countryId = Counties.countryId
  and (Countries.name = 'France' OR Countries.name = 'Germany');


-- b
SELECT name
FROM Countries
WHERE population > 50000000
INTERSECT
SELECT name
FROM Countries
WHERE name NOT LIKE '%ma%';


-- b, e
SELECT name
FROM Counties
WHERE Counties.countryId = 1
  AND name IN (SELECT name
               FROM Counties
               WHERE population > 10000000);


-- c
SELECT name
FROM Countries
WHERE population > 50000000
EXCEPT
(SELECT name
 FROM Countries
 WHERE name = 'Germany');


-- c
SELECT name
FROM Countries
WHERE population > 50000000
  AND name not in (SELECT name
                   FROM Countries
                   WHERE name = 'Germany');


-- d, top
SELECT *
FROM Countries
         INNER JOIN CountryPartOfRegion
                    ON Countries.countryId = CountryPartOfRegion.countryId
         INNER JOIN ContinentalRegions
                    ON CountryPartOfRegion.continentalRegionId = ContinentalRegions.continentalRegionId
LIMIT 5;


-- d, ORDER by
SELECT Countries.name, C.name
FROM Countries
         LEFT JOIN Counties C
                   ON Countries.countryId = C.countryId
ORDER BY C.name;


-- d
SELECT Cities.name, Countries.name
FROM Countries
         RIGHT JOIN Cities
                    ON Countries.capitalId = Cities.cityId;


-- d
SELECT ContinentalRegions.name, Countries.name, CountryRegions.name, Counties.name
FROM ContinentalRegions
         JOIN CountryPartOfRegion
              ON ContinentalRegions.continentalRegionId = CountryPartOfRegion.continentalRegionId
         JOIN Countries
              ON CountryPartOfRegion.countryId = Countries.countryId
         JOIN CountryRegions
              ON Countries.countryId = CountryRegions.countryId
         JOIN CountyPartOfRegion
              ON CountryRegions.countryRegionId = CountyPartOfRegion.countryRegionId
         JOIN Counties
              ON CountyPartOfRegion.countyId = Counties.countyId;


-- d, top
SELECT *
FROM ContinentalRegions
         JOIN CountryPartOfRegion
              ON ContinentalRegions.continentalRegionId = CountryPartOfRegion.continentalRegionId
         JOIN Countries
              ON CountryPartOfRegion.countryId = Countries.countryId
         JOIN Counties
              ON Countries.countryId = Counties.countryId
LIMIT 10;


-- e, distinct
SELECT name
FROM ContinentalRegions
WHERE continentalRegionId IN (SELECT continentalRegionId
                              FROM CountryPartOfRegion
                              WHERE countryId IN (SELECT countryId
                                                  FROM Countries
                                                  WHERE (SELECT COUNT(DISTINCT countyId)
                                                         FROM Counties
                                                         WHERE Countries.countryId = Counties.countryId) > 5));


-- f
SELECT name
FROM ContinentalRegions
WHERE EXISTS (SELECT continentalRegionId
              FROM CountryPartOfRegion
              WHERE ContinentalRegions.continentalRegionId = CountryPartOfRegion.continentalRegionId
                AND CountryPartOfRegion.countryId IN (SELECT countryId
                                                      FROM Countries
                                                      WHERE (SELECT COUNT(DISTINCT countyId)
                                                             FROM Counties
                                                             WHERE Countries.countryId = Counties.countryId) > 5));

-- g
SELECT *
FROM (SELECT population, name
      FROM Countries
      WHERE capitalId IS NOT NULL) as C
WHERE C.population > (SELECT AVG(population)
                      FROM Countries);

-- g, order by
SELECT *
FROM (SELECT population, name
      FROM Cities
      WHERE countyId IN (SELECT countyId
                         FROM Counties
                         WHERE countryId IN (1, 2))) as C
WHERE C.population > (SELECT AVG(population)
                      FROM Cities)
ORDER BY C.population DESC;


-- f
SELECT name
FROM Counties C
WHERE C.countryId = 1
  AND EXISTS (SELECT name
              FROM Counties C1
              WHERE C1.population > 10000000
                AND C1.name = C.name);


-- h
SELECT C1.name, SUM(C.population)
FROM (Cities C INNER JOIN Counties C1 on C.countyId = C1.countyId)
GROUP BY C1.countyId;


-- h
SELECT C1.name, COUNT(C.countryId)
FROM (Countries C1 INNER JOIN Counties C on C1.countryId = C.countryId)
GROUP BY C.countryId
HAVING COUNT(C.countryId) > 5;

-- h, Distinct
SELECT C1.name, SUM(C.population)
FROM (Cities C INNER JOIN Counties C1 on C.countyId = C1.countyId)
GROUP BY C1.countyId
HAVING SUM(C.population) > (SELECT AVG(DISTINCT population)
                            FROM Cities);

-- h, distinct
SELECT CountryRegions.name, SUM(Counties.population)
FROM (Counties INNER JOIN CountyPartOfRegion ON Counties.countyId = CountyPartOfRegion.countyId INNER JOIN CountryRegions
      ON CountyPartOfRegion.countryRegionId = CountryRegions.countryRegionId)
GROUP BY CountryRegions.name
HAVING SUM(Counties.population) > (SELECT AVG(DISTINCT population)
                                   FROM Counties);

-- i
SELECT *
FROM Cities C
WHERE C.population > ANY
    (SELECT C1.population
     FROM Cities C1
     WHERE C1.countyId IN (SELECT C2.countyId
                           FROM Counties C2
                           WHERE C2.countryId = 1));


SELECT *
FROM Cities C
WHERE C.population > (SELECT MIN(C1.population)
     FROM Cities C1
     WHERE C1.countyId IN (SELECT C2.countyId
                           FROM Counties C2
                           WHERE C2.countryId = 1));


-- i
SELECT *
FROM Cities C
WHERE C.population > ALL
    (SELECT C1.population
     FROM Cities C1
     WHERE C1.countyId IN (SELECT C2.countyId
                           FROM Counties C2
                           WHERE C2.countryId = 1));


SELECT *
FROM Cities C
WHERE C.population > (SELECT MAX(C1.population)
     FROM Cities C1
     WHERE C1.countyId IN (SELECT C2.countyId
                           FROM Counties C2
                           WHERE C2.countryId = 1));

-- i
SELECT *
FROM Counties C
WHERE C.population > ANY
    (SELECT C1.population
     FROM Counties C1
     WHERE C1.countryId = 6);

SELECT *
FROM Counties C
WHERE C.population NOT IN
    (SELECT C1.population
     FROM Counties C1
     WHERE C1.population <= (SELECT MIN(C2.population)
                             FROM Counties C2
                             WHERE C2.countryId = 6));

-- i
SELECT *
FROM Counties C
WHERE C.population > ALL
    (SELECT C1.population
     FROM Counties C1
     WHERE C1.countryId = 6);

SELECT *
FROM Counties C
WHERE C.population NOT IN
    (SELECT C1.population
     FROM Counties C1
     WHERE C1.population <= (SELECT MAX(C2.population)
                             FROM Counties C2
                             WHERE C2.countryId = 6))
ORDER BY C.population DESC;















