-- SELECT from WORLD
-- Observe the result of running this SQL command to show the name, continent and population of all countries
SELECT name, continent, population FROM world
-- Show the name for the countries that have a population of at least 200 million.
SELECT name FROM world
WHERE population >= 200000000 
-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
select name, GDP/population FROM world
where population >=200000000 
-- Show the name and population in millions for the countries of the continent 'South America'. 
select name, population/1000000 FROM world
where continent = 'South America'
-- Show the name and population for France, Germany, Italy
select name, population FROM world
where name IN ('France', 'Germany', 'Italy')
-- Show the countries which have a name that includes the word 'United'
select name From world

where name like '%United%'
-- Show the countries that are big by area or big by population. Show name, population and area.
select name, population, area FROM world
where area >= 3000000 OR population >= 250000000
-- Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area
select name, population, area FROM world
where area >= 3000000 OR population >= 250000000

-- Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'.
select name, ROUND(population/1000000,2), ROUND(GDP/1000000000,2)  FROM world
where continent = 'South America'
-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
select name, ROUND(GDP/population,-3) from world
where GDP >= 1000000000000
-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name,  capital FROM world
 WHERE LENGTH(name) = LENGTH(capital)
-- Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name,
         capital FROM world WHERE LEFT(name, 1) = LEFT(capital, 1) AND name <> capital  
        --  Find the country that has all the vowels and no spaces in its name.

SELECT name
FROM world
WHERE name LIKE '%a%'
        AND name LIKE '%e%'
        AND name LIKE '%i%'
        AND name LIKE '%o%'
        AND name LIKE '%u%'
        AND name NOT LIKE '% %' 
         