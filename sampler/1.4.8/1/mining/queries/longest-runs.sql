-- runs ordered by sum of predicate counts, largest first

CREATE TEMPORARY TABLE results AS
SELECT run_id, build.*, sum(count) as weight
FROM run_sample NATURAL JOIN build
GROUP BY run_id;

ALTER TABLE results ADD PRIMARY KEY (run_id);

INSERT IGNORE INTO results
SELECT run_id, build.*, 0
FROM run NATURAL JOIN build;

SELECT * FROM results
ORDER BY weight DESC;
