open Cil
open Printf


class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    print_string ("visiting function " ^ func.svar.vname ^ "\n");
    let (root, stmts) = Cfg.cfg func in

    printf "\n********************\ntop-level block structure:\n";
    Utils.print_stmts func.sbody.bstmts;
    printf "\n********************\n";

    let fringe = ref [] in
    let rec explore ancestors stmt =
      let succs = stmt.succs in
      
      let is_ancestor successor =
	let result = List.mem successor ancestors in
	if result then printf "back edge: %i -> %i\n" stmt.sid successor.sid;
	result
      in
      
      if List.exists is_ancestor succs then
	fringe := !fringe @ succs
      else
	List.iter (explore (stmt :: ancestors)) succs
    in
    
    explore [] root;
    ignore(Pretty.printf "fringe:\n%a\n\n" Utils.d_stmts !fringe);

    SkipChildren
end
    
;;

let file = TestHarness.main [new visitor] in
printFile defaultCilPrinter stdout file
