SELECT sessions.session, signal, site, name, line, value
  FROM
    (SELECT * FROM samples_int32 WHERE expression = 'next_array') as next_arrays
    NATURAL JOIN sites
    NATURAL JOIN files
    NATURAL JOIN sessions
  ORDER BY signal;
