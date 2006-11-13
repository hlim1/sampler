-- number of new reports per week, suitable for histogram plotting

SELECT year(date) as year, week(date) as week, count(*)
FROM run
GROUP BY year, week
ORDER BY year, week;
