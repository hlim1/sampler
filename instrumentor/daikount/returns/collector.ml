open Cil


class visitor file =
  let invariant = Invariant.invariant file in

  fun func ->
    let invariant = invariant func in

    object
      inherit FunctionBodyVisitor.visitor

      val mutable sites = []
      val mutable globals = []
      method result : Sites.info = sites, globals

      method vstmt stmt =
	match stmt.skind with
	| Instr [Call (Some result, callee, args, location)] ->
	    let (global, site) = invariant location result zero in
	    globals <- global :: globals;
	    sites <- site :: sites;
	    stmt.skind <- Block (mkBlock ([mkStmt stmt.skind; site]));
	    SkipChildren

	| Instr (_ :: _ :: _) as instr ->
	    currentLoc := get_stmtLoc instr;
	    ignore (bug "instr should have been atomized");
	    SkipChildren

	| _ ->
	    DoChildren
    end


let collect file =
  let visitor = new visitor file in
  fun func ->
    let visitor = visitor func in
    ignore (visitCilFunction (visitor :> cilVisitor) func);
    visitor#result
