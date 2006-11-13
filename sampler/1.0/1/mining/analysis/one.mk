root := ../../../../../../cbiexp
datadir := data
# confidence := 95
time :=
xmllint := :

default: bug-o-meter.css bug-o-meter.dtd bug-o-meter.xsl predictor-info.dtd predictor-info.xml projections.dtd projections.xml summary.xml all_lb_none.xml


$(datadir)/stamp-labels:
	echo $(numRuns) >$@

include $(root)/src/analysis-rules.mk
