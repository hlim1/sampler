open Cil

	
class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    let nodeCount = List.length (computeCFGInfo func) in

    let backEdges = new SetClass.container and
	postCallEdges = new SetClass.container and
	arrived = new SetClass.container and
	forwardWeights = new MapClass.container nodeCount and
	backwardWeights = new MapClass.container nodeCount in
    
    let rec explore stmt =

      arrived#add stmt;
      
      if endsWithCall stmt then
	List.iter (fun succ -> postCallEdges#add (stmt, succ)) stmt.succs;
      
      let descend succ =
	if not (arrived#mem succ) then
	  explore succ
	else
	  try weights#find succ with
	  | Not_found ->
	      backEdges#add (stmt, succ);
	      0
      in
      
      let maximize champ contender = max champ (descend contender) in
      let heaviest = List.fold_left maximize 0 stmt.succs in
      let myWeight = Stores.count_stmt stmt in
      let total = heaviest + myWeight in
      weights#add stmt total;
      total
    in
    
    ignore (explore (List.hd func.sbody.bstmts));
    
    backEdges#iter begin
      fun (src, dst) ->
	Printf.printf "back edge from CFG #%i to CFG #%i\n" src.sid dst.sid
    end;
    
    weights#iter begin
      fun stmt stores ->
	Printf.printf "path from CFG #%i has weight %i\n" stmt.sid stores
    end;
    
    SkipChildren
end
    
;;

let visitor = new visitor in
ignore(TestHarness.main visitor)
