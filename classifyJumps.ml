open Cil


type direction = Forward | Backward


class visitor = object
  inherit FunctionBodyVisitor.visitor

  val seen = new StmtSet.container
  val classifications = new StmtMap.container

  method vfunc _ =
    ignore(bug "ClassifyJumps.visitor can only be used within a function body");
    SkipChildren

  method vstmt stmt =
    begin
      match stmt.skind with
      | Goto (destination, _) ->
	  let direction =
	    if seen#mem !destination then
	      Backward
	    else
	      Forward
	  in
	  classifications#add stmt direction
      | _ -> ()
    end;
    seen#add stmt;
    DoChildren

  method result = classifications
end


let visit {sbody = sbody} =
  let visitor = new visitor in
  ignore(visitCilBlock (visitor :> cilVisitor) sbody);
  visitor#result
