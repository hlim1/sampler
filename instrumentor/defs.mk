ifdef profile
native := 1
ocamlflags := -p
endif

ifdef native
ocamlc := ocamlopt.opt
cma := cmxa
cmo := cmx
else
ocamlflags := -g
ocamlc := ocamlc.opt
cma := cma
cmo := cmo
endif
