open Cil


type map = (exp * lval * location) StmtMap.container


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val map = new StmtMap.container
  method result = map

  method vstmt statement =
    begin
      match statement.skind with
      |	Instr [Set((Mem address, NoOffset), Lval data, location)] ->
	  map#add statement (address, data, location)
      | _ ->
	  ()
    end;
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
