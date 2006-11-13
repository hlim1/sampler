-- failed runs by date, most recent first

SELECT *
FROM run NATURAL JOIN build
WHERE exit_signal
ORDER BY date DESC;
