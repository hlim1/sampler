open Cil
open Foreach


class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    ignore (computeCFGInfo func);

    let backEdges = new SetClass.container and
	arrived = new SetClass.container and
	departed = new SetClass.container in
    
    let rec explore stmt =
      arrived#add stmt;
      foreach stmt.succs begin
	fun succ ->
	  if not (arrived#mem succ) then
	    explore succ
	  else if not (departed#mem succ) then
	    backEdges#add (stmt, succ)
      end;
      departed#add stmt
    in
    
    explore (List.hd func.sbody.bstmts);
    
    backEdges#iter begin
      fun (src, dst) ->
	Printf.printf "back edge from CFG #%i to CFG #%i\n" src.sid dst.sid
    end;
    
    SkipChildren
end
    
;;

let visitor = new visitor in
ignore(TestHarness.main [visitor])
