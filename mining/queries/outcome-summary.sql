-- outcome of each applcation's runs, ordered by crash frequency

SELECT
    application_name,
    count(*),
    sum(!exit_status AND !exit_signal) AS good,
    sum(!!exit_status) AS error,
    sum(!!exit_signal) AS crash,
    sum(!!exit_signal) / sum(!exit_status AND !exit_signal) AS crash_rate
FROM run NATURAL JOIN build
WHERE !(application_name = 'evolution' AND build_date < '2003-8-25' AND exit_signal)
GROUP BY application_name
ORDER BY crash_rate DESC
