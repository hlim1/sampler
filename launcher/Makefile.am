SUBDIRS = applications

py := $(wildcard *.py)
pyo = $(py:=o)

MOSTLYCLEANFILES = $(pyo)

all-local: $(pyo)

$(pyo): %.pyo: %.py
	python -O -c 'import $*' || rm -f $@
	[ -r $@ ]

mains:
	python -O -c 'import GnomeMain'
	python -O -c 'import Main'
