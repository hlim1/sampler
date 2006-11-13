-- number of new reports per week, suitable for histogram plotting

SELECT year(date) as year, week(date) as week, application_name, count(*) as count
FROM run
NATURAL JOIN build
GROUP BY year, week, application_name
ORDER BY year, week, application_name;
