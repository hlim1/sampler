open Cil


type map = (lval * location) StmtMap.container


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val sites = new StmtMap.container
  method result = sites

  method vstmt statement =
    begin
      match statement.skind with
      |	Instr [Set (lval, _, location)]
      |	Instr [Call (Some lval, _, _, location)] ->
	  sites#add statement (lval, location)
      | _ ->
	  ()
    end;
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
