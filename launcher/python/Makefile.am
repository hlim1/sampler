py := $(wildcard *.py)
pyc = $(py:=c)
pyo = $(py:=o)

launcher_DATA = $(pyc) $(pyo)

EXTRA_DIST = $(py)
MOSTLYCLEANFILES = *.pyc *.pyo

compile = -c 'import py_compile; py_compile.compile("$<");'

$(pyc): %.pyc: %.py
	python $(compile)

$(pyo): %.pyo: %.py
	python -O $(compile)
