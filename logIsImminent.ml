open Cil
  

let nextLogCountdown =
  makeGlobalVar "nextLogCountdown" uintType


let choose location weight instrumented original =
  let within = kinteger IUInt weight in
  let countdown = Lval (var nextLogCountdown) in
  let predicate = BinOp (Le, within, countdown, intType) in
  If (predicate, original, instrumented, location)
    
    
let addPrototype file =
  file.globals <- GVarDecl (nextLogCountdown, nextLogCountdown.vdecl) :: file.globals


let phase =
  "LogIsImminent",
  addPrototype
