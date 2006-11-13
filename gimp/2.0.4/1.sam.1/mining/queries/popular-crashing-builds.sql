-- find builds with the most crashes

SELECT build_distribution, application_name, application_version, application_release, build_date, count(*) as reports, sum(!!exit_signal) as crashes
FROM run NATURAL JOIN build
WHERE build_suppress IS NULL
GROUP BY build.build_id
ORDER BY crashes DESC;
