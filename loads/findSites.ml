open Cil
open OutputSet


let collect = function
    (* Switch has been removed by Cil.prepareCFG *)
  | Return (Some expression, _)
  | If (expression, _, _, _) ->
      Collect.collect visitCilExpr expression
  | Instr [instruction] ->
      Collect.collect visitCilInstr instruction
  | _ ->
      OutputSet.empty
