open Cil


let bump file =
  let bumper = Threads.bump file in
  fun location expression counters ->
    let bnot exp = UnOp (LNot, exp, typeOf exp) in
    let offset = Index (bnot (bnot expression), NoOffset) in
    let counter = addOffsetLval offset counters in

    Instr [bumper counter location]
