dir := $(HOME)/research/forensics/sampling/apps/bc-1.06/trials

ifndef psts
 ifdef glob
  psts := $(wildcard $(glob))
 else
  traces := $(wildcard $(dir)/*.trace.gz)
  trials := $(notdir $(traces:.trace.gz=))
  psts := $(trials:=.pst)
 endif
endif

all: run-hunt

psts: $(psts)

run-hunt: unknown-hunt $(psts)
	./$^

$(psts): %.pst: $(dir)/%.trace.gz $(dir)/%.result
	./rebuild-pst-one $@ $^
