-- do expensive filtering just once
DROP TEMPORARY TABLE IF EXISTS focus;
CREATE TEMPORARY TABLE focus
(INDEX (unit_signature, site_order, predicate))
SELECT run_sample.*
FROM run_sample NATURAL JOIN run
-- WHERE build_id = 20
;


------------------------------------------------------------------------


-- F(P)
DROP TEMPORARY TABLE IF EXISTS fail_predicate;
CREATE TEMPORARY TABLE fail_predicate
(INDEX (unit_signature, site_order, predicate))
SELECT unit_signature, site_order, predicate, count(*) as count
FROM focus INNER JOIN run USING (run_id)
WHERE exit_signal > 0
GROUP BY unit_signature, site_order, predicate;


-- S(P)
DROP TEMPORARY TABLE IF EXISTS succeed_predicate;
CREATE TEMPORARY TABLE succeed_predicate
(INDEX (unit_signature, site_order, predicate))
SELECT unit_signature, site_order, predicate, count(*) as count
FROM focus INNER JOIN run USING (run_id)
WHERE exit_signal = 0
GROUP BY unit_signature, site_order, predicate;

-- F(P | ¬P)
DROP TEMPORARY TABLE IF EXISTS fail_site;
CREATE TEMPORARY TABLE fail_site
(INDEX (unit_signature, site_order))
SELECT unit_signature, site_order, count(*) as count
FROM focus INNER JOIN run USING (run_id)
WHERE exit_signal > 0
GROUP BY unit_signature, site_order;

-- S(P | ¬P)
DROP TEMPORARY TABLE IF EXISTS succeed_site;
CREATE TEMPORARY TABLE succeed_site
(INDEX (unit_signature, site_order))
SELECT unit_signature, site_order, count(*) as count
FROM focus INNER JOIN run USING (run_id)
WHERE exit_signal = 0
GROUP BY unit_signature, site_order;


------------------------------------------------------------------------


-- Crash(P)
DROP TEMPORARY TABLE IF EXISTS crash;
CREATE TEMPORARY TABLE crash
(INDEX (unit_signature, site_order))
SELECT fail_predicate.unit_signature, fail_predicate.site_order, fail_predicate.predicate, fail_predicate.count / (succeed_predicate.count + fail_predicate.count) as score
FROM fail_predicate INNER JOIN succeed_predicate
USING (unit_signature, site_order, predicate);

-- Context(P)
DROP TEMPORARY TABLE IF EXISTS context;
CREATE TEMPORARY TABLE context
(INDEX (unit_signature, site_order))
SELECT fail_site.unit_signature, fail_site.site_order, fail_site.count / (succeed_site.count + fail_site.count) as score
FROM fail_site INNER JOIN succeed_site
USING (unit_signature, site_order);


------------------------------------------------------------------------


-- ranked results
DROP TEMPORARY TABLE IF EXISTS increase;
CREATE TEMPORARY TABLE increase
(INDEX (crash, context))
SELECT crash.unit_signature, crash.site_order, predicate, crash.score as crash, context.score as context, crash.score - context.score as increase
FROM crash INNER JOIN context
USING (unit_signature, site_order)
WHERE crash.score > context.score;

-- connect results back to source locations
SELECT application_name, application_version, application_release, source_name, line_number, function, operand_0, operand_1, increase.predicate, increase, crash, context, count as fail_count
FROM increase
INNER JOIN build_site USING (unit_signature, site_order)
INNER JOIN build USING (build_id)
INNER JOIN fail_predicate
	ON increase.unit_signature = fail_predicate.unit_signature
	AND increase.site_order = fail_predicate.site_order
	AND increase.predicate = fail_predicate.predicate
ORDER BY crash DESC, context ASC, count DESC
LIMIT 200;
