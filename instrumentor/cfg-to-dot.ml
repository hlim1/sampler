open Cil
  

type cfg = stmt * stmt list

let cfg func =
  prepareCFG func;
  let stmts = computeCFGInfo func false in
  let root = List.hd func.sbody.bstmts in

  if root.sid != 0 then
    ignore(bug "first statement in function body is not root of CFG");

  (root, stmts)


class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    method vfunc func =
      let (_, stmts) = cfg func in
      Pretty.fprint stdout 80 (CfgToDot.d_cfg stmts);
      SkipChildren
	
  end
    
;;

initCIL ();
Arg.parse [] (TestHarness.doOne ["cfg-to-dot", visitCilFileSameGlobals new visitor]) "";
