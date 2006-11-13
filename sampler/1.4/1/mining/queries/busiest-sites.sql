-- currently hard wired to nautilus-2.2.4-0.ximian.6.5.sam.1

SELECT source_name, line_number, function, operand_0, sum(count) as sum

FROM build_site NATURAL JOIN run_sample
WHERE build_site.build_id = 18

GROUP BY build_site.unit_signature, build_site.site_order

ORDER BY sum DESC
LIMIT 10;
