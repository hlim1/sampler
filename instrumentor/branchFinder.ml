open Cil


let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor (tuples : CounterTuples.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method vstmt stmt =
      match stmt.skind with
      | If (predicate, thenClause, elseClause, location)
	when self#includedStatement stmt ->
	  let predTemp = var (Locals.makeTempVar func (typeOf predicate)) in
	  let selector = BinOp (Ne, Lval predTemp, zero, intType) in
	  let bump = tuples#addSite func selector (d_exp () predicate) location in
	  let replacement = Block (mkBlock [mkStmtOneInstr (Set (predTemp, predicate, location));
					    bump;
					    mkStmt (If (Lval predTemp,
							thenClause,
							elseClause,
							location))])
	  in
	  ChangeDoChildrenPost (stmt, postpatch replacement)

      | _ ->
	  DoChildren
  end
