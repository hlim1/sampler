all: $(addprefix ds1000ngood_plot., eps pdf)

ds1000ngood_plot.eps: %.eps: ngood_plot.m %.mat
	rm -f $@
	matlab -nodisplay -nojvm -nosplash -r $(basename $<) </dev/null
	[ -r $@ ]
