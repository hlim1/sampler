open Cil


class visitor file =
  let counters = Counters.build file in

  fun global func ->
    object (self)
      inherit Classifier.visitor global as super

      val mutable sites = []
      method sites = sites

      method private patchConditional stmt =
	begin
	  match stmt.skind with
	  | If (predicate, thenClause, elseClause, location) ->
	      let (lval, site, profile) = counters func location predicate in
	      self#addGlobal profile;
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
	ignore (super#vstmt stmt);
	match stmt.skind with
	| If _ ->
	    ChangeDoChildrenPost (stmt, self#patchConditional)
	| _ ->
	    DoChildren
    end
