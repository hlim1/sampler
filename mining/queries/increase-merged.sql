-- enumerate distinct build sites if we ignore certain fields
DROP TABLE IF EXISTS merged_build_site;
CREATE TABLE merged_build_site
(merged_site_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
 application_name VARCHAR(50) NOT NULL,
 source_name VARCHAR(255) NOT NULL,
 line_number INT UNSIGNED NOT NULL,
 function VARCHAR(255) NOT NULL,
 operand_0 VARCHAR(255) NOT NULL,
 operand_1 VARCHAR(255),
 INDEX (line_number, source_name, application_name));

INSERT INTO merged_build_site
SELECT DISTINCT NULL, application_name, source_name, line_number, function, operand_0, operand_1
FROM build_site
INNER JOIN build USING (build_id)
-- WHERE build.build_id = 37
-- LIMIT 100
;


-- enumerate observations using the same scheme
DROP TABLE IF EXISTS merged_run_sample;
CREATE TABLE merged_run_sample
(PRIMARY KEY (run_id, merged_site_id, predicate))

SELECT DISTINCT run.run_id, merged_site_id, predicate
FROM run_sample
INNER JOIN run USING (run_id)
INNER JOIN build USING (build_id)
INNER JOIN build_site USING (build_id)
INNER JOIN merged_build_site
    ON build.application_name = merged_build_site.application_name
    AND build_site.source_name = merged_build_site.source_name
    AND build_site.line_number = merged_build_site.line_number
    AND build_site.function = merged_build_site.function
    AND build_site.operand_0 = merged_build_site.operand_0
    AND build_site.operand_1 = merged_build_site.operand_1
;


-- compute F(P) and S(P)
DROP TABLE IF EXISTS tally_predicate;
CREATE TABLE tally_predicate
(PRIMARY KEY (merged_site_id, predicate))

SELECT merged_site_id, predicate,
       SUM(exit_signal > 0) as failure_count,
       SUM(exit_signal = 0) as success_count
FROM merged_run_sample
INNER JOIN run USING (run_id)
GROUP BY merged_site_id, predicate;


-- combine all predicates at each site
DROP TABLE IF EXISTS merged_run_sample_site;
CREATE TABLE merged_run_sample_site
(PRIMARY KEY (run_id, merged_site_id))

SELECT DISTINCT run_id, merged_site_id
FROM merged_run_sample;


-- compute Badness(P)
DROP TABLE IF EXISTS tally_badness;
CREATE TABLE tally_badness
(PRIMARY KEY (merged_site_id, predicate))

SELECT merged_site_id, predicate, failure_count / (failure_count + success_count) AS badness
FROM tally_predicate;


-- compute F(P | ¬P) and S(P | ¬P)
DROP TABLE IF EXISTS tally_site;
CREATE TABLE tally_site
(PRIMARY KEY (merged_site_id))

SELECT merged_site_id,
       SUM(exit_signal > 0) as failure_count,
       SUM(exit_signal = 0) as success_count
FROM merged_run_sample_site
INNER JOIN run USING (run_id)
GROUP BY merged_site_id;


-- compute Context(P)
DROP TABLE IF EXISTS tally_context;
CREATE TABLE tally_context
(PRIMARY KEY (merged_site_id))

SELECT merged_site_id, failure_count / (failure_count + success_count) AS context
FROM tally_site;


-- compute Increase(P)
DROP TABLE IF EXISTS tally_increase;
CREATE TABLE tally_increase
(PRIMARY KEY (merged_site_id, predicate),
 INDEX(increase DESC))

SELECT tally_badness.merged_site_id, tally_badness.predicate, badness - context AS increase
FROM tally_badness
INNER JOIN tally_context USING (merged_site_id)
WHERE badness > context;


-- connect ranked results back to source locations
SELECT
    tally_increase.merged_site_id, tally_increase.predicate,
    application_name, source_name, line_number, function, operand_0, operand_1,
    tally_predicate.failure_count, tally_predicate.success_count, badness,
    tally_site.failure_count, tally_site.success_count, context,
    increase
FROM tally_increase
INNER JOIN tally_predicate USING (merged_site_id, predicate)
INNER JOIN tally_badness USING (merged_site_id, predicate)
INNER JOIN tally_site USING (merged_site_id)
INNER JOIN tally_context USING (merged_site_id)
INNER JOIN merged_build_site USING (merged_site_id)
ORDER BY increase DESC
-- LIMIT 200
;
