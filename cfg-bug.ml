open Cil
  

class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    let stmts = computeCFGInfo func in

    List.iter begin
      fun stmt ->
	Printf.printf "%i:" stmt.sid;
	List.iter (fun succ -> Printf.printf " %i" succ.sid) stmt.succs;
	print_newline ()
    end
      stmts;
    
    SkipChildren
      
end
    
;;

let file = Frontc.parse "bug.c" () in
visitCilFileSameGlobals (new SplitAfterCalls.visitor) file;
visitCilFileSameGlobals (new visitor) file
