-- number of new reports per day, suitable for histogram plotting

-- the horrible cast(concat_ws(...) ...) stuff is standing in for
-- date(...), which only becomes available in MySQL 4.1.1

-- even in spite of that cast, the data doesn't seem to be treated as
-- date unless we put it into a temporary table first

CREATE TEMPORARY TABLE buckets AS
SELECT cast(concat_ws('-', year(date), month(date), dayofmonth(date)) as DATE) as bucket, application_name, count(*)
FROM run
NATURAL JOIN build
GROUP BY bucket, application_name;

SELECT *
FROM buckets
ORDER BY bucket, application_name;
