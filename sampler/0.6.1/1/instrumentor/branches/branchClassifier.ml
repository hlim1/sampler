open Cil


let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor (counters : Counters.builder) func =
  object (self)
    inherit Classifier.visitor func

    method vstmt stmt =
      match stmt.skind with
      | If (predicate, thenClause, elseClause, location)
	when self#includedStatement stmt ->
	  let site = mkEmptyStmt () in
	  let (lval, bump) = counters#bump func location site predicate in
	  site.skind <- bump;
	  sites <- site :: sites;
	  let replacement = Block (mkBlock [mkStmtOneInstr (Set (lval, predicate, location));
					   site;
					   mkStmt (If (Lval lval,
						       thenClause,
						       elseClause,
						       location))])
	  in
	  ChangeDoChildrenPost (stmt, postpatch replacement)

      | _ ->
	  DoChildren
  end
