open Cil
open OutputSet


class visitor logger = object
  inherit Sites.visitor

  method consider skind =
    let outputs =
      match skind with
	(* Switch has been removed by Cil.prepareCFG *)
      | Return (Some expression, _)
      | If (expression, _, _, _) ->
	  Collect.collect visitCilExpr expression
      | Instr [instruction] ->
	  Collect.collect visitCilInstr instruction
      | _ ->
	  OutputSet.empty
    in
    if OutputSet.is_empty outputs then
      None
    else
      let location = get_stmtLoc skind in
      let instrumentation = Logs.build logger outputs location in
      Some instrumentation
end
