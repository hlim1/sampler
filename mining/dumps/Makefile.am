EXTRA_DIST =					\
	dump					\
	dump-schema				\
	schema.sql


all-local: schema.sql

schema.sql: dump-schema
	./$< >$@.tmp
	mv $@.tmp $@

complete.sql.gz: dump ../populate/sync-stamp
	./$< --opt | gzip >$@.tmp
	mv $@.tmp $@
