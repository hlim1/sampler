ifdef ENABLE_PROFILING
ENABLE_NATIVE := 1
ocamlflags += -p
endif

ifdef ENABLE_NATIVE
ocamlc := ocamlopt.opt
cma := cmxa
cmo := cmx
else
ocamlflags += -g
ocamlc := ocamlc.opt
cma := cma
cmo := cmo
endif
