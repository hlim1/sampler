open Cil
open Foreach


class visitor = object
  inherit nopCilVisitor
      
  val loopHeaders = ref []
  val loopEscapes = ref []

  method vstmt stmt =
    begin
      match stmt.skind with
      |	Loop({bstmts = header :: _}, _) ->
	  loopHeaders := header :: !loopHeaders;
      | _ -> ()
    end;
    DoChildren

  method getLoops = !loopHeaders
      
end
    
;;

let visitor = new visitor in
ignore(TestHarness.main visitor);
ignore(Pretty.printf "loop headers according to syntax tree:@!  @[%a@]@!"
	 Utils.d_stmts visitor#getLoops)
