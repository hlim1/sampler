ifndef number
$(error must define $$(number))
endif


testDir := spec95/$(number).$(name)/src

include ../rules.mk
