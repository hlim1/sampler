open Cil


type set = StmtSet.container


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val set = new StmtSet.container
  method result = set

  method vstmt statement =
    begin
      match statement.skind with
      |	Instr [Set((Mem _, NoOffset), _, _)] ->
	  set#add statement
      | _ ->
	  ()
    end;
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
