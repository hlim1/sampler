open Cil
open Clude


let shouldTransform { svar = svar } =
  not (hasAttribute "no_instrument_function" svar.vattr)
