-- bug: does not account for zeros; sample table is sparse

SELECT
    application_name,
    application_version,
    application_release,
    outcome,
    count,
    object_name,
    source_name,
    line_number,
    function,
    operand_0,
    operand_1,
    avg(count) AS average
FROM sample NATURAL JOIN site NATURAL JOIN build
GROUP BY sample.site_id
ORDER BY average DESC
