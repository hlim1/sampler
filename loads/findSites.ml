open Cil
open OutputSet


class sites = [OutputSet.t] StmtMap.container
      

class visitor = object
  inherit FunctionBodyVisitor.visitor

  val sites = new sites
  method result = sites

  method vstmt statement =
    let outputs =
      match statement.skind with
	(* Switch has been removed by Cil.prepareCFG *)
      | Return (Some expression, location)
      | If (expression, _, _, location) ->
	  Collect.collect visitCilExpr expression
      |	Instr [instruction] ->
	  Collect.collect visitCilInstr instruction
      | _ ->
	  OutputSet.empty
    in
    if not (OutputSet.is_empty outputs) then
      sites#add statement outputs;
    
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
