CREATE SEQUENCE session_seq;

CREATE TABLE sessions (
  session int NOT NULL CHECK (session > 0) PRIMARY KEY DEFAULT NEXTVAL('session_seq'),
  application text NOT NULL CHECK (application <> ''),
  sparsity int NOT NULL CHECK (sparsity > 0),
  seed int NOT NULL CHECK (seed > 0),
  inputSize int NOT NULL CHECK (inputSize > 0),
  signal smallint NOT NULL CHECK (signal >= 0)
);


CREATE SEQUENCE file_seq;

CREATE TABLE files (
  file int NOT NULL PRIMARY KEY DEFAULT NEXTVAL('file_seq'),
  name text NOT NULL CHECK (name <> ''),

  UNIQUE (name)
);


CREATE TABLE sites (
  session int NOT NULL CHECK (session > 0) REFERENCES sessions MATCH FULL,
  site bigint NOT NULL CHECK (site > 0),
  file int NOT NULL REFERENCES files,
  line int NOT NULL CHECK (line > 0),

  UNIQUE (session, site)
);


CREATE TABLE samples (
  session int NOT NULL CHECK (session > 0),
  site bigint NOT NULL CHECK (site > 0),
  expression text NOT NULL CHECK (expression <> ''),
  type smallint NOT NULL CHECK (type BETWEEN 1 AND 15),
  value text NOT NULL CHECK (value <> ''),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
);


-- CREATE INDEX samples_expression_value ON samples (expression, value);
-- CREATE INDEX sites_file_line ON sites (file, line);
