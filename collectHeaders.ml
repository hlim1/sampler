open Cil
open Foreach
open Printf


type headers = EdgeSet.container

    
let collectLoopHeaders headers root =
  let arrived = new StmtSet.container
  and departed = new StmtSet.container in

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
    | [] -> ()
    | [succ] -> headers#add (stmt, succ)
    | _ -> failwith (sprintf "CFG #%i contains call with %i successors" stmt.sid (List.length stmt.succs))
	

let collectPostCallHeaders headers stmts =
  List.iter (collectPostCallHeader headers) stmts


(**********************************************************************)


let collectHeaders (root, stmts) =
  let headers = new EdgeSet.container in
  
  headers#add (dummyStmt, root);
  collectLoopHeaders headers root;
  collectPostCallHeaders headers stmts;
  headers


(**********************************************************************)


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    let (root, stmts) as cfg = Cfg.cfg func in
    
    print_endline ("visiting function " ^ func.svar.vname);
    printf "\theaders from entry: 1: (%i, %i)\n" dummyStmt.sid root.sid;

    let loopHeaders = new EdgeSet.container in
    collectLoopHeaders loopHeaders root;
    printf "\theaders from loops: %i:" loopHeaders#size;
    loopHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let callHeaders = new EdgeSet.container in
    collectPostCallHeaders callHeaders stmts;
    printf "\theaders from calls: %i:" callHeaders#size;
    callHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let headers = collectHeaders cfg in
    printf "\ttotal: %i:" headers#size;
    headers#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    SkipChildren
end
