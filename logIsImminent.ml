open Cil
  

let choose location weight countdown instrumented original =
  let within = kinteger IUInt weight in
  let predicate = BinOp (Le, within, countdown, intType) in
  If (predicate, original, instrumented, location)
