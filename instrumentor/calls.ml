open Cil


type info = {
    export : stmt;
    callee : exp;
    import : stmt;
    jump : stmt;
    landing : stmt;
  }

type infos = info list


class prepatcher =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable placeholders = []
    method result = placeholders

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (_, callee, _, _) as call] ->
	  let info = {
	    export = mkEmptyStmt ();
	    callee = callee;
	    import = mkEmptyStmt ();
	    jump = mkEmptyStmt ();
	    landing = mkEmptyStmt ()
	  }
	  in
	  placeholders <- info :: placeholders;
	  
	  let block = Block (mkBlock [info.export;
				      mkStmtOneInstr call;
				      info.import;
				      info.jump;
				      info.landing])
	  in
	  stmt.skind <- block;
	  SkipChildren

      | _ ->
	  DoChildren
  end


let prepatch visitor {sbody = sbody} =
  ignore (visitCilBlock (visitor :> cilVisitor) sbody);
  visitor#result
