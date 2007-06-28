-- of all the features (predicates) in each build, how many were
-- actually seen on at least one run?

------------------------------------------------------------------------
--
--  how many predicates are in each build?
--

CREATE TEMPORARY TABLE sites_per_build
SELECT build_id, count(*) AS site_count
FROM build_site
GROUP BY build_id;

CREATE TEMPORARY TABLE predicates_per_build
SELECT build.build_id, predicates_per_site * site_count AS total
FROM sites_per_build, build, instrumentation
WHERE sites_per_build.build_id = build.build_id
AND build.instrumentation_type = instrumentation.instrumentation_type;

------------------------------------------------------------------------
--
--  how many predicates were observed in at least one run?
--

CREATE TEMPORARY TABLE ever_observed
SELECT DISTINCT build_id, unit_signature, site_order, predicate
FROM run_sample;

CREATE TEMPORARY TABLE ever_observed_count
SELECT build_id, count(*) as seen
FROM ever_observed
GROUP BY build_id;

------------------------------------------------------------------------
--
--  put the two together
--

SELECT concat_ws('-', application_name, application_version, application_release) as build, total, seen, seen / total as ratio
FROM predicates_per_build NATURAL JOIN ever_observed_count NATURAL JOIN build
ORDER BY application_name, application_version, application_release;
