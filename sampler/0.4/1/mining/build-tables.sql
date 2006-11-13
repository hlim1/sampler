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


------------------------------------------------------------------------


CREATE TABLE samples (
  session int NOT NULL CHECK (session > 0),
  site bigint NOT NULL CHECK (site > 0),
  expression text NOT NULL CHECK (expression <> '')
);


CREATE TABLE samples_int8 (
  value smallint NOT NULL CHECK (value BETWEEN -128 AND 127),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_uint8 (
  value int2 NOT NULL CHECK (value BETWEEN 0 AND 255),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_int16 (
  value int2 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_uint16 (
  value int4 NOT NULL CHECK (value BETWEEN 0 AND 65535),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_int32 (
  value int4 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_uint32 (
  value int8 NOT NULL CHECK (value BETWEEN 0 AND 4294967295),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_int64 (
  value int8 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_uint64 (
  value int8 NOT NULL CHECK (value >= 0),

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_float32 (
  value float4 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_float64 (
  value float8 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_float96 (
  value float8 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);


CREATE TABLE samples_pointer32 (
  value int4 NOT NULL,

  UNIQUE (session, site, expression),
  FOREIGN KEY (session, site) REFERENCES sites (session, site) MATCH FULL
) INHERITS (samples);
