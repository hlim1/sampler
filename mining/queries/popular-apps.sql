-- find builds with the most runs

SELECT application_name, count(*) AS repeats
FROM run NATURAL JOIN build
GROUP BY application_name
ORDER BY repeats DESC;
