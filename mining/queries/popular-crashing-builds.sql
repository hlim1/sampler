-- find builds with the most crashes

SELECT build_distribution, application_name, application_version, application_release, build_date, count(*) as reports, sum(!!exit_signal) as crashes
FROM run NATURAL JOIN build
WHERE !(application_name = 'evolution' AND build_date < '2003-8-25' and exit_signal)
GROUP BY build.build_id
ORDER BY crashes DESC;
