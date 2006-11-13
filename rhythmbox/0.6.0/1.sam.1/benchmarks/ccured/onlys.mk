ifdef buildOnlys
-include functions.mk
ifneq (,$(filter all none, $(functions)))
$(name conflict: error benchmark defines an "all" or "none" function)
endif
endif
