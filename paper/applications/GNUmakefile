benchdir := ../../benchmarks
matlab := matlab -nodisplay -nojvm -nosplash $(basename $<) </dev/null

default: all


########################################################################


include ccured.mk
include ccrypt.mk
include bc.mk


########################################################################


all: tex eps pdf
.PHONY: all

tex: $(tex:=.tex)
.PHONY: tex

eps: $(eps:=.eps)
.PHONY: eps

pdf: $(eps:=.pdf)
.PHONY: pdf

%.pdf: %.eps
	epstopdf --outfile=$@ $<
