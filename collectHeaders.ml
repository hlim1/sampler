open Cil
open Foreach
open Printf
    
    
let collectLoopHeaders headers root =
  let arrived = new SetClass.container
  and departed = new SetClass.container in

  let rec explore stmt =
    arrived#add stmt;
    
    foreach stmt.succs begin
      fun succ ->
	if not (arrived#mem succ) then
	  explore succ
	else if not (departed#mem succ) then
	  headers#add (stmt, succ)
    end;

    departed#add stmt
  in
  
  explore root


(**********************************************************************)


let rec endsWithCall_instrs = function
  | [] -> false
  | [Call _] -> true
  | Call _ :: _ -> failwith "found call before end of instruction list"
  | _ :: tail -> endsWithCall_instrs tail
	
	
let endsWithCall {skind = skind} =
  match skind with
  | Instr(instrs) -> endsWithCall_instrs instrs
  | _ -> false
	

let collectPostCallHeader headers stmt =
  if endsWithCall stmt then
    match stmt.succs with
    | [succ] -> headers#add (stmt, succ)
    | _ -> failwith "found call with non-singleton successor set"
	

let collectPostCallHeaders headers stmts =
  List.iter (collectPostCallHeader headers) stmts


(**********************************************************************)


let collectHeaders root stmts =
  let headers = new SetClass.container in
  
  headers#add (dummyStmt, root);
  collectLoopHeaders headers root;
  collectPostCallHeaders headers stmts;
  headers


(**********************************************************************)


class visitor = object
  inherit nopCilVisitor
      
  method vfunc func =
    prepareCFG func;
    let stmts = computeCFGInfo func
    and root = List.hd func.sbody.bstmts in

    print_endline ("visiting function " ^ func.svar.vname);
    printf "\theaders from entry: 1: (%i, %i)\n" dummyStmt.sid root.sid;

    let loopHeaders = new SetClass.container in
    collectLoopHeaders loopHeaders root;
    printf "\theaders from loops: %i:" loopHeaders#size;
    loopHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let callHeaders = new SetClass.container in
    collectPostCallHeaders callHeaders stmts;
    printf "\theaders from calls: %i:" callHeaders#size;
    callHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let headers = collectHeaders root stmts in
    printf "\ttotal: %i:" headers#size;
    headers#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    SkipChildren
end
    
;;

let splitter = new SplitAfterCalls.visitor
and collector = new visitor in
ignore(TestHarness.main [splitter; collector])
