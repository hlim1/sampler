-- find builds with the most runs

SELECT application_name, count(*) AS reports
FROM run NATURAL JOIN build
WHERE !(application_name = 'evolution' AND build_date < '2003-8-25' AND exit_signal)
GROUP BY application_name
ORDER BY reports DESC;
