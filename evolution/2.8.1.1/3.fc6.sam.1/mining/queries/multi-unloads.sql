SELECT unit_signature, count(*) AS repeats
FROM run_sample
GROUP BY run_id
HAVING repeats > 1
ORDER BY repeats DESC
