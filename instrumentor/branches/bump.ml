open Cil


let bump location expression counters =
  let bnot exp = UnOp (LNot, exp, typeOf exp) in
  let offset = Index (bnot (bnot expression), NoOffset) in
  let counter = addOffsetLval offset counters in

  Instr [Set (counter, increm (Lval counter) 1, location)]
