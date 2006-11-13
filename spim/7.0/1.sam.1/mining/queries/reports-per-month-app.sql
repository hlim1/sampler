-- number of new reports per week, suitable for histogram plotting

SELECT year(date) as year, month(date) as month, application_name, count(*) as count
FROM run
NATURAL JOIN build
GROUP BY year, month, application_name
ORDER BY year, month, application_name;
