open Cil
  

class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    prepareCFG func;
    let stmts = computeCFGInfo func in

    List.iter begin
      fun stmt ->
	let name = Utils.stmt_what stmt.skind in
	Printf.printf "%i (%s):" stmt.sid name;
	List.iter (fun succ -> Printf.printf " %i (%s)" succ.sid (Utils.stmt_what succ.skind)) stmt.succs;
	print_newline ()
    end
      stmts;
    
    SkipChildren
      
end
    
;;

let file = Frontc.parse "bug.c" () in
Check.checkFile [] file;
visitCilFileSameGlobals (new SplitAfterCalls.visitor) file;
Check.checkFile [] file;
visitCilFileSameGlobals (new visitor) file;
Check.checkFile [] file
