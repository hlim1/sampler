open Cil
  

let choose location weight instrumented original =
  let within = kinteger IUInt weight in
  let countdown = Lval Countdown.lval in
  let predicate = BinOp (Le, within, countdown, intType) in
  If (predicate, original, instrumented, location)
