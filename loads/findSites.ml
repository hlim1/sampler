open Cil
open OutputSet


type map = OutputSet.t StmtMap.container
      

class visitor = object
  inherit FunctionBodyVisitor.visitor

  val map = new StmtMap.container
  method result = map

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
      map#add statement outputs;
    
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
