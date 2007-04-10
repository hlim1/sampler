-- "%/plugins/%" pattern is only applicable to Gnumeric

CREATE TEMPORARY TABLE used_module
SELECT DISTINCT module_name, run_id
FROM build_module NATURAL JOIN run_sample
WHERE module_name LIKE '%/plugins/%';

SELECT module_name, count(*) as count
FROM used_module
GROUP BY module_name
ORDER BY count DESC;
