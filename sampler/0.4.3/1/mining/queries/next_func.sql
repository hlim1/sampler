SELECT sessions.session, signal, site, name, line, value
  FROM sessions NATURAL JOIN sites NATURAL JOIN files NATURAL JOIN samples_int32
  WHERE expression = 'next_func'
  ORDER BY signal;
