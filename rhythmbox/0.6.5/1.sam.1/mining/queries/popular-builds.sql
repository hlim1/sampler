-- find builds with the most runs

SELECT build.*, count(*) AS repeats
FROM run NATURAL JOIN build
GROUP BY run.build_id
ORDER BY repeats DESC;
