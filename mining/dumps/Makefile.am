EXTRA_DIST =					\
	dump					\
	dump-schema				\
	schema.sql


complete.sql.gz: dump ../populate/sync-stamp
	./$< --opt | gzip >$@.tmp
	mv $@.tmp $@
