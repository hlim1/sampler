SELECT checksum, count(*) AS repeats
FROM unit
GROUP BY report_id
HAVING repeats > 1
ORDER BY repeats DESC
