open Cil
open Helpers

let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor file =
  fun (tuples : Counters.manager)  func ->
    object (self)
      inherit SiteFinder.visitor

      method vstmt stmt =
	match IsolateInstructions.isolated stmt with
	| Some (Set (left, expr, location) as instr)
	  when self#includedStatement stmt ->
	    begin
	      match SharedAccesses.isolated instr with
	      | None -> ()
	      | Some _ ->
		  let predTemp = var (findOrCreate_local func "cbi_yieldsTmp") in
		  let predLval = Lval predTemp in

		  let selector = BinOp (Ne, predLval, zero, intType) in
		  let bump,siteId = tuples#addExpr selector in
		  let bump = mkStmtOneInstr bump in
		  let initTemp = mkStmtOneInstr (Set (predTemp, zero, locUnknown)) in
		  let siteInfo = new InstrSiteInfo.c func location (Set (left, expr, location)) in
		  let cci_func = Lval (var (FindFunction.find "cbi_yield" file)) in
		  let cci_call = Call (Some predTemp, cci_func, [integer siteId], location) in
		  let thump = tuples#addSiteInstrs siteInfo [cci_call] in

		  let orig = mkStmtOneInstr instr in
		  stmt.skind <- Block (mkBlock [orig; initTemp; thump; bump])
	    end;
	    SkipChildren
	| _ -> 
	    DoChildren
    end
