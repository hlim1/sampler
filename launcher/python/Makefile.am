py := $(wildcard *.py)
pyc = $(py:=c)
pyo = $(py:=o)

MOSTLYCLEANFILES = *.pyc *.pyo

all-local: $(pyc) $(pyo)

$(pyc): %.pyc: %.py
	python -W all -c 'import $*' || rm -f $@
	[ -r $@ ]

$(pyo): %.pyo: %.py
	python -O -W all -c 'import $*' || rm -f $@
	[ -r $@ ]
