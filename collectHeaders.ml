open Cil
open Foreach
open Printf


type headers = EdgeSet.container


(**********************************************************************)


let collectHeaders ((root, stmts) as cfg) =
  let headers = new EdgeSet.container in
  
  headers#add (dummyStmt, root);
  LoopHeaders.collect headers root;
  CallHeaders.collect headers stmts;
  headers


(**********************************************************************)


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vfunc func =
    let (root, stmts) as cfg = Cfg.cfg func in
    
    print_endline ("visiting function " ^ func.svar.vname);
    printf "\theaders from entry: 1: (%i, %i)\n" dummyStmt.sid root.sid;

    let loopHeaders = new EdgeSet.container in
    LoopHeaders.collect loopHeaders root;
    printf "\theaders from loops: %i:" loopHeaders#size;
    loopHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let callHeaders = new EdgeSet.container in
    CallHeaders.collect callHeaders stmts;
    printf "\theaders from calls: %i:" callHeaders#size;
    callHeaders#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    let headers = collectHeaders cfg in
    printf "\ttotal: %i:" headers#size;
    headers#iter (fun (s, d) -> printf " (%i, %i)" s.sid d.sid);
    print_newline ();

    SkipChildren
end
