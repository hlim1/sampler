open Cil
open Clude


let functionFilter = ref []


let _ =
  Clude.register
    ~flag:"function"
    ~desc:"<function> instrument this function"
    ~ident:"FilterFunction"
    functionFilter


let shouldTransform { svar = svar } =
  not (hasAttribute "no_instrument_function" svar.vattr)
    && filter !functionFilter svar.vname == Include
