SELECT sessions.session, signal, site, name, line, value
  FROM
    (SELECT * FROM samples_int32 WHERE expression = 'next_func') as next_funcs
    NATURAL JOIN sites
    NATURAL JOIN files
    NATURAL JOIN sessions
  ORDER BY signal;
