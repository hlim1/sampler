open Cil


type set = StmtSet.container


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val set = new StmtSet.container
  method result = set

  method vstmt statement =
    begin
      match statement.skind with
      |	Instr (instruction :: instructions) ->
	  assert (instructions == []);
	  begin
	    match instruction with
	    | Set _
	    | Call (Some _, _, _, _) ->
		set#add statement
	    | _ -> ()
	  end;
      | _ ->
	  ()
    end;
    DoChildren
end


let visit block =
  let visitor = new visitor in
  ignore (visitCilBlock (visitor :> cilVisitor) block);
  visitor#result
