open Cil


let bump file =
  let bumper = Bumper.build file in
  fun site location left right ->
    let bin op a b = BinOp (op, a, b, intType) in
    let cmp op = bin op left right in
    let ge = cmp Ge in
    let gt = cmp Gt in
    let slot = bin PlusA ge gt in
    
    Instr [bumper site slot location]
