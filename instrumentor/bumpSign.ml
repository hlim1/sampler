open Cil


let bump file =
  let bumper = Threads.bump file in
  fun location left right counters ->
    let bin op a b = BinOp (op, a, b, intType) in
    let cmp op = bin op left right in
    let ge = cmp Ge in
    let gt = cmp Gt in
    
    let offset = Index (bin PlusA ge gt, NoOffset) in
    let counter = addOffsetLval offset counters in

    Instr [bumper counter location]
