-- currently hard wired to evolution-1.4.4-0.ximian.6.1.sam.3

SELECT function, sum(count) as sample_sum

FROM build_site NATURAL JOIN run_sample
WHERE build_site.build_id = 5

GROUP BY function

ORDER BY sample_sum DESC
LIMIT 15;
