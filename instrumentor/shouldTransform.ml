open Cil


let shouldTransform func =
  not (hasAttribute "no_instrument_function" func.svar.vattr)
