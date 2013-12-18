open Cil

let postpatch replacement statement =
  statement.skind <- replacement;
  statement

class visitor (tuples : Counters.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method! vstmt stmt =
      if self#includedStatement stmt then
	let location = get_stmtLoc stmt.skind in
	if location.line > -1 then
	  match stmt.skind with (* todo: skip scalar pairs instrumentation (performance bug)  *)
	    Block (_) ->
	      DoChildren
	    | _ ->
	      let siteInfo = new StmtSiteInfo.c func location stmt in
	      let bump, _ = tuples#addSiteOffset siteInfo NoOffset in
	      let replacement = Block (mkBlock [bump; mkStmt stmt.skind]) in
	      ChangeDoChildrenPost (stmt, postpatch replacement)
	else
	  DoChildren
      else
	DoChildren
  end
