open Cil
open Dominators
  
  
class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    let stmts = computeCFGInfo func in
    let dominators = computeDominators stmts (List.hd func.sbody.bstmts) in
    
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
    
;;

print_string "digraph Dominators {\n";
ignore(TestHarness.main new visitor);
print_string "}\n"
