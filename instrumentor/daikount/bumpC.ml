open Cil


let bump _ location left right counters =
  let bin op a b = BinOp (op, a, b, intType) in
  let cmp op = bin op (Lval left) right in
  let ge = cmp Ge in
  let gt = cmp Gt in
  
  let offset = Index (bin PlusA ge gt, NoOffset) in
  let counter = addOffsetLval offset counters in

  mkStmtOneInstr (Set (counter, increm (Lval counter) 1, location))
