open Cil
open Foreach
open Pretty


class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    let nodeCount = List.length (computeCFGInfo func) in

    let backEdges = new SetClass.container and
	arrived = new SetClass.container and
	weights = new MapClass.container nodeCount in
    
    let rec explore stmt =

      arrived#add stmt;
      
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
      let myWeight = heaviest + 1 in
      weights#add stmt myWeight;
      myWeight
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
