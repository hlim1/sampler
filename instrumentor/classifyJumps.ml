open Cil


type info = { forward : stmt list; backward : stmt list }


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val seen = new StmtIdHash.c 0
	
    val mutable forward = []
    val mutable backward = []
    method result = { forward; backward }

    method! vstmt stmt =
      begin
	match stmt.skind with
	| Goto (destination, _) ->
	    if seen#mem !destination then
	      backward <- stmt :: backward
	    else
	      forward <- stmt :: forward
	| Break _
	| Continue _
	| Loop _ ->
	    ignore (bug "loop constructs should have been converted into gotos");
	    failwith "internal error"
	| _ -> ()
      end;
      seen#add stmt ();
      DoChildren

    method! vfunc func =
      NumberStatements.visit func;
      DoChildren
  end


let visit func =
  let visitor = new visitor in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#result
