open Cil


class visitor =
  object
    inherit nopCilVisitor

    val collection = new Int64Set.container
    method collection = collection

    method vexpr exp =
      begin
	match exp with
	| Const (CInt64 (constant, _, _)) ->
	    if not (collection#mem constant) then
	      collection#add constant
	| _ ->
	    ()
      end;
      DoChildren
  end


let visit file =
  let visitor = new visitor in
  visitCilFileSameGlobals (visitor :> cilVisitor) file;
  visitor#collection
