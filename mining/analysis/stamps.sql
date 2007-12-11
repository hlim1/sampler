SELECT application_name, application_version, application_release, build_distribution
FROM run
  NATURAL JOIN build
  LEFT JOIN run_suppress USING (run_id)
  LEFT JOIN build_suppress USING (build_id)
WHERE   run_suppress.reason IS NULL
  AND build_suppress.reason IS NULL
  AND deployment_name = 'default'
GROUP BY application_name, application_version, application_release, build_distribution
  HAVING COUNT(NULLIF(exit_signal = 0, FALSE)) > 1
     AND COUNT(NULLIF(exit_signal = 0, TRUE )) > 1
