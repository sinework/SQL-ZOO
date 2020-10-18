-- More JOIN
-- 
-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962
--  When was Citizen Kane released?
SELECT yr
  FROM movie
  WHERE title = 'Citizen Kane'
  -- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie
  WHERE title LIKE '%Star Trek%'
  ORDER BY yr
SELECT title FROM movie
  WHERE id IN (11768, 11955, 21191)
-- What id number does the actor 'Glenn Close' have?  
SELECT id FROM actor
  WHERE name = 'Glenn Close'
  -- id for Casablanca
SELECT id FROM movie
  WHERE title = 'Casablanca'
  -- Obtain the cast list for 'Casablanca'.
SELECT name FROM casting JOIN actor ON (id=actorid)
  WHERE movieid=11768
  -- Obtain the cast list for the film 'Alien'
SELECT name FROM casting
  JOIN actor ON (actor.id=actorid)
  JOIN movie ON (movie.id=movieid)
  WHERE title = 'Alien'
  -- List the films in which 'Harrison Ford' has appeared
SELECT title FROM casting
  JOIN movie ON (movie.id = movieid)
  JOIN actor ON (actor.id = actorid)
  WHERE name = 'Harrison Ford'
  -- List the films in which 'Harrison Ford' has appeared
   
SELECT title FROM casting
  JOIN movie ON (movie.id = movieid)
  JOIN actor ON (actor.id = actorid)
  WHERE name = 'Harrison Ford'  AND ord > 1
  --List the films together with the leading star for all 1962 films. 
SELECT title, name FROM casting
  JOIN movie ON (movie.id = movieid)
  JOIN actor ON (actor.id = actorid)
  WHERE yr = 1962 and ord = 1
-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 WHERE name='John Travolta'
 GROUP BY yr) AS t
)
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name FROM casting
  JOIN movie ON movie.id = movieid
  JOIN actor ON actor.id = actorid
WHERE ord = 1
	AND movie.id IN
	(SELECT movie.id FROM movie
	   JOIN casting ON movie.id = movieid
	   JOIN actor ON actor.id = actorid
           WHERE actor.name = 'Julie Andrews')
-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT DISTINCT name FROM casting
  JOIN movie ON movie.id = movieid
  JOIN actor ON actor.id = actorid
  WHERE actorid IN (
	SELECT actorid FROM casting
	  WHERE ord = 1
	  GROUP BY actorid
	  HAVING COUNT(actorid) >= 15)
ORDER BY name
-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) FROM casting
  JOIN movie ON movieid = movie.id
  WHERE yr = 1978
  GROUP BY movieid, title
  ORDER BY COUNT(actorid) DESC
  -- List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name FROM casting
  JOIN actor ON actorid = actor.id
  WHERE name != 'Art Garfunkel'
	AND movieid IN (
		SELECT movieid
		FROM movie
		JOIN casting ON movieid = movie.id
		JOIN actor ON actorid = actor.id
		WHERE actor.name = 'Art Garfunkel'
)