EXTRA_DIST =					\
	schema.sql


all-local: schema.sql

schema.sql:
	pg_dump --clean --schema-only --no-owner --no-privileges --file=$@.
	sed -e '/^COMMENT ON SCHEMA public IS /s/^/-- /' <$@. >$@
	rm $@.

complete.sql.gz: dump ../populate/sync-stamp
	./$< --opt | gzip >$@.tmp
	mv $@.tmp $@

.DELETE_ON_ERROR:
