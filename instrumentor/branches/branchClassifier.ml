open Cil


class visitor (counters : Counters.builder) func =
    object (self)
      inherit Classifier.visitor as super

      val mutable sites = []
      method sites = sites

      method private patchConditional stmt =
	begin
	  match stmt.skind with
	  | If (predicate, thenClause, elseClause, location) ->
	      let (lval, site) = counters#bump func location predicate in
	      let site = mkStmt site in
	      sites <- site :: sites;
	      stmt.skind <- Block (mkBlock [mkStmtOneInstr (Set (lval, predicate, location));
					    site;
					    mkStmt (If (Lval lval,
							thenClause,
							elseClause,
							location))])
	  | _ ->
	      failwith "cannot patch non-conditional"
	end;
	stmt

      method vstmt stmt =
	let action = super#vstmt stmt in
	match stmt.skind with
	| If _ ->
	    ChangeDoChildrenPost (stmt, self#patchConditional)
	| _ ->
	    action
    end
