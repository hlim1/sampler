open Cil
open Dominators
  
  
class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    method vfunc func =
      let (_, stmts) as cfg = Cfg.cfg func in
      let dominators = computeDominators cfg in
      
      let print_stmt stmt =
	ignore(Pretty.printf "%a" Dotify.d_node stmt);
	match dominators#idom stmt with
	| None -> ()
	|	Some(idom) ->
	    ignore(Pretty.printf "%a" (fun _ -> Dotify.d_edge () idom) stmt)
      in
      List.iter print_stmt (List.rev stmts);

      SkipChildren
  end
    

let phase =
  "Dom-to-dot",
  fun file ->
    print_string "digraph Dominators {\n";
    visitCilFileSameGlobals new visitor file;
    print_string "}\n"

;;

ignore(TestHarness.main [phase]);
