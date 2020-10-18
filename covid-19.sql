--  Modify the query to show data from Spain.
SELECT
  name, DAY(whn), confirmed, deaths, recovered
FROM
  covid
WHERE
  name = 'Spain' AND MONTH(whn) = 3
ORDER BY
  whn;

--  Modify the query to show confirmed for the day before.
SELECT
  name, DAY(whn), confirmed,LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
FROM
  covid
WHERE
  name = 'Italy' AND MONTH(whn) = 3
ORDER BY
  whn;

-- Show the number of new cases for each day, for Italy, for March.
SELECT
  name, DAY(whn), confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) as new
FROM
  covid
WHERE
  name = 'Italy' AND MONTH(whn) = 3
ORDER BY
  whn;

--  Show the number of new cases in Italy for each week - show Monday only.
SELECT
  name, DATE_FORMAT(whn,'%Y-%m-%d'), confirmed-LAG(confirmed,1) OVER (ORDER BY whn) 'new this week'
FROM
  covid
WHERE
  name = 'Italy' and WEEKDAY(whn) = 0;

-- Show the number of new cases in Italy for each week - show Monday only (using JOIN and DATE_ADD).
SELECT
  tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), tw.confirmed - lw.confirmed
FROM
  covid tw LEFT JOIN covid lw ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn AND tw.name = lw.name
WHERE
  tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0
ORDER BY
  tw.whn;
-- Include the ranking for the number of deaths in the table.
SELECT 
  name, confirmed, RANK() OVER (ORDER BY confirmed DESC) rc, deaths, RANK() OVER (ORDER BY deaths DESC) rc
FROM
  covid
WHERE
  whn = '2020-04-20'
ORDER BY
  confirmed DESC;
-- Show the infect rate ranking for each country. Only include countries with a population of at least 10 million.
SELECT 
  world.name, ROUND(100000*confirmed/population,0), RANK() OVER (ORDER BY confirmed/population) AS rank
FROM
  covid JOIN world ON covid.name=world.name
WHERE whn = '2020-04-20' AND population > 10000000
ORDER BY
  population DESC;
--  For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.
SELECT
  name,DATE_FORMAT(whn,'%Y-%m-%d'), newCases AS peakNewCases
FROM
  (SELECT name, whn, newCases, RANK() OVER (PARTITION BY name ORDER BY newCases DESC) rnc
FROM
  (SELECT name, whn, confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) as newCases
FROM
  covid
) AS x
) AS y
WHERE rnc = 1 AND newCases > 1000
ORDER BY whn;