open Cil
open Helpers
open Interesting

let postpatch replacement statement =
  statement.skind <- replacement;
  statement

class visitor (tuples : Counters.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method! vstmt stmt =
      match stmt.skind with
        | Instr [Set (left, _, _) as instr] when self#includedStatement stmt ->
	  begin
	    match SharedAccesses.isolated instr with
	      | Some lval when ((not (is_bitfield lval)) && (isDiscreteType (typeOfLval lval))) ->
		let accessType =
		  if left == lval then
		    AccessSiteInfo.Write
		  else
		    AccessSiteInfo.Read
		in
		let selector =
		  if !Counters.trace then
		    Index (mkCast (mkAddrOf lval) !upointType, NoOffset)
		  else
		    NoOffset
		in
		let siteInfo = new AccessSiteInfo.c func !currentLoc lval accessType in
		let bump, _ = tuples#addSiteOffset siteInfo selector in
		let replacement = Block (mkBlock [bump; mkStmt stmt.skind]) in
		ChangeDoChildrenPost (stmt, postpatch replacement)
	      | _ ->
		SkipChildren
	  end;
	| _ ->
	  DoChildren
  end
