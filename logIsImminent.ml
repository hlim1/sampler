open Cil
  

let choose location weight countdown instrumented original =
  let within = kinteger IUInt weight in
  let predicate = BinOp (Gt, countdown, within, intType) in
  If (predicate, original, instrumented, location)
