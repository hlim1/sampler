open Cil


class visitor =
  object
    inherit FunctionBodyVisitor.visitor
	
    method vfunc func =
      let (_, stmts) = Cfg.cfg func in
      Pretty.fprint stdout 80 (CfgToDot.d_cfg stmts);
      SkipChildren
	
  end
    
;;

ignore(TestHarness.main ["cfg-to-dot", visitCilFileSameGlobals new visitor]);
