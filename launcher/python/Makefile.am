py := $(wildcard *.py)
pyc = $(py:=c)
pyo = $(py:=o)

launcher_SCRIPTS = $(pyc) $(pyo)

EXTRA_DIST = $(py)
MOSTLYCLEANFILES = *.pyc *.pyo

$(pyc): %.pyc: %.py
	python -W all -c 'import $*' || rm -f $@
	[ -r $@ ]

$(pyo): %.pyo: %.py
	python -O -W all -c 'import $*' || rm -f $@
	[ -r $@ ]
