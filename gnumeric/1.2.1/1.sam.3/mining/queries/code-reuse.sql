-- find units which appear in more than one build

CREATE TEMPORARY TABLE units
SELECT DISTINCT build_id, unit_signature
FROM build_site;

SELECT unit_signature, count(*) AS repeats
FROM units
GROUP BY unit_signature
HAVING repeats > 1
ORDER BY repeats DESC;
