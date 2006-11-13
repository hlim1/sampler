SELECT sessions.session, signal, site, name, line, value
  FROM samples_int32 NATURAL JOIN sites NATURAL JOIN files NATURAL JOIN sessions
  WHERE expression = 'next_func'
  ORDER BY signal;
