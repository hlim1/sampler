open Cil
open Dotify
open Pretty
  

class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    ignore (Cfg.cfg func);
    DoChildren

  method vstmt stmt =
    fprint stdout 80
      (indent 2 (d_node () stmt
		   ++ seq nil (d_edge () stmt) stmt.succs));
    DoChildren
      
end
    
;;

print_string "digraph CFG {\n";
ignore(TestHarness.main [new SplitAfterCalls.visitor; new visitor]);
print_string "}\n"
