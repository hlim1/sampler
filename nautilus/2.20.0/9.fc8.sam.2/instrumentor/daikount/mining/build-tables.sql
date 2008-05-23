CREATE SEQUENCE sessions_seq;

CREATE TABLE sessions (
  id int NOT NULL CHECK (id > 0) PRIMARY KEY DEFAULT NEXTVAL('sessions_seq'),
  application text NOT NULL CHECK (application <> ''),
  sparsity int NOT NULL CHECK (sparsity > 0),
  seed int NOT NULL CHECK (seed > 0),
  inputSize int NOT NULL CHECK (inputSize > 0),
  signal smallint NOT NULL CHECK (signal >= 0)
);


CREATE SEQUENCE sites_seq;

CREATE TABLE sites (
  id int NOT NULL PRIMARY KEY DEFAULT NEXTVAL('sites_seq'),
  file NOT NULL CHECK (file <> ''),
  line int NOT NULL CHECK (line > 0),
  func NOT NULL CHECK (fun <> ''),
  left NOT NULL CHECK (left <> ''),
  right NOT NULL CHECK (right <> ''),
  number int NOT NULL CHECK (number > 0)
);


CREATE TABLE counters (
  session int NOT NULL REFERENCES sessions.id,
  site int NOT NULL REFERENCES sites.id,
  less int NOT NULL CHECK (less >= 0),
  equal int NOT NULL CHECK (equal >= 0),
  greater int NOT NULL CHECK (greater >= 0),

  UNIQUE (session, site)
);
