open Cil
open Foreach


class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    val loopHeaders = ref []
    val loopEscapes = ref []

    method vstmt stmt =
      begin
	match stmt.skind with
	|	Loop({bstmts = header :: _}, _, _, _) ->
	    loopHeaders := header :: !loopHeaders;
	| _ -> ()
      end;
      DoChildren

    method getLoops = !loopHeaders
	
  end
    

let phase =
  "FindLoopsAST",
  fun file ->
    let visitor = new visitor in
    visitCilFileSameGlobals (visitor :> cilVisitor) file;
    ignore (Pretty.printf "loop headers according to syntax tree:@!  @[%a@]@!"
	      Utils.d_stmts visitor#getLoops)
      
;;

ignore(TestHarness.main [phase]);
