CREATE SEQUENCE session_seq;


CREATE TABLE sessions (
  session int NOT NULL CHECK (session > 0) PRIMARY KEY DEFAULT NEXTVAL('session_seq'),
  signal smallint NOT NULL CHECK (signal >= 0)
);


CREATE TABLE sites (
  session int NOT NULL CHECK (session > 0) REFERENCES sessions MATCH FULL,
  sample int NOT NULL CHECK (sample > 0),
  file text NOT NULL CHECK (file <> ''),
  line int NOT NULL CHECK (line > 0),

  UNIQUE (session, sample)
);


CREATE TABLE samples (
  session int NOT NULL CHECK (session > 0),
  sample int NOT NULL CHECK (sample > 0),
  expression text NOT NULL CHECK (expression <> ''),
  type smallint NOT NULL CHECK (type BETWEEN 1 AND 15),
  value text NOT NULL CHECK (value <> ''),

  UNIQUE (session, sample, expression),
  FOREIGN KEY (session, sample) REFERENCES sites (session, sample) MATCH FULL
);
