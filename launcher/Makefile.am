SUBDIRS = applications

py := $(filter-out launcher.py, $(wildcard *.py))
pyo = $(py:=o)

MOSTLYCLEANFILES = $(pyo)

all-local: $(pyo)

$(pyo): %.pyo: %.py
	python -O -c 'import $*' || rm -f $@
	[ -r $@ ]

