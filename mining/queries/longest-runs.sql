-- runs ordered by sum of predicate counts, largest first

SELECT run_id, build.*, sum(count) as weight
FROM run_sample NATURAL JOIN build
GROUP BY run_id
ORDER BY weight DESC;
