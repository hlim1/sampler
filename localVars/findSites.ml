open Cil


class sites = StmtSet.container


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val sites = new sites
  method result = sites

  method vstmt statement =
    begin
      match statement.skind with
      | Instr [_] ->
	  sites#add statement
      | _ ->
	  ()
    end;

    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
