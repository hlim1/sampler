EXTRA_DIST =					\
	Common.pm				\
	common.py				\
	freshen-builds				\
	freshen-runs				\
	sync-from-www

noinst_PYTHON =					\
	common.py				\
	insertBuilds.py				\
	insertRuns.py				\
	integrityChecks.py

TESTS = $(noinst_PYTHON)
TESTS_ENVIRONMENT = pychecker --quiet --stdlib
