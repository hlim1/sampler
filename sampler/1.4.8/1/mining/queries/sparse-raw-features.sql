-- predicate counts suitable for import into a sparse MATLAB array


------------------------------------------------------------------------
--
--  enumerate predicates that were observed in at least one run
--

CREATE TEMPORARY TABLE ever_observed
(feature_id INTEGER UNSIGNED AUTO_INCREMENT NOT NULL, PRIMARY KEY (feature_id))
SELECT DISTINCT unit_signature, site_order, predicate
FROM run_sample
WHERE build_id = 17;		-- gnumeric-1.2.0-1.sam.1


------------------------------------------------------------------------
--
--  spit out nicely sorted sparse array of numbered features
--

SELECT run_id, feature_id, count
FROM run_sample NATURAL JOIN ever_observed
WHERE build_id = 17		-- redundant but helps SQL optimizer
ORDER BY run_id, feature_id;


------------------------------------------------------------------------
--
--  spit out key mapping feature numbers back to source
--

SELECT feature_id, source_name, line_number, function, operand_0, operand_1, predicate
FROM ever_observed NATURAL JOIN build_site
WHERE build_id = 17		-- redundant but helps SQL optimizer
ORDER BY feature_id;
