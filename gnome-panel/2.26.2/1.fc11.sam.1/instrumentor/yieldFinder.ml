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
	(*TODO: write isInterestingStmt function*)

	let isInterestingLvalOption file left = 
	  match left with None -> false | Some(lv) -> isInterestingLval file lv in
	
	let rec isInterestingExpList file args = 
	  match args with [] -> false | arg::rest -> isInterestingExp file arg || isInterestingExpList file rest in

	let isInterestingCall file left args = 
	  isInterestingLvalOption file left || isInterestingExpList file args in 

	match IsolateInstructions.isolated stmt with
	| Some( Call(left, callee, args, location))
	  when self#includedStatement stmt ->
	    begin
	      if (isInterestingCall file left args) then
		begin
	      (* foo() =>  *)
(* 	      foo(); *)
(* 	      temp=0; *)
(* 	      temp=cbi_yield(); *)
(* 	      counters[index](temp==0); *)
	      let predTemp = var (findOrCreate_local func "cbi_yieldsTmp") in
	      let predLval = Lval predTemp in
	      let selector = BinOp (Ne, predLval, zero, intType) in
	      let initTemp = mkStmtOneInstr (Set (predTemp, zero, locUnknown)) in
	      let siteInfo = new InstrSiteInfo.c func location (Call(left, callee, args, location)) in
	      let bump,siteId = tuples#addExpr selector  in	
	      let bump = mkStmtOneInstr bump in
	      let cci_func = Lval (var (FindFunction.find "cbi_yield" file)) in
	      let cci_call = Call (Some(predTemp), cci_func, [integer siteId], location) in
	      let thump = tuples#addSiteInstrs siteInfo [cci_call] in

	      let orig = mkStmtOneInstr (Call(left, callee, args, location)) in
	      stmt.skind <- Block (mkBlock [orig;initTemp; thump; bump ]);
	      end;
	    end;
	    SkipChildren
	| Some(Set (left, expr, location))
	  when self#includedStatement stmt ->
	    begin
	      if (isInterestingLval file left || isInterestingExp  file expr ) then
		begin

		  let predTemp = var (findOrCreate_local func "cbi_yieldsTmp") in
		  let predLval = Lval predTemp in

		  let selector = BinOp (Ne, predLval, zero, intType) in
		  let bump,siteId = tuples#addExpr selector in
		  let bump = mkStmtOneInstr bump in
		  let initTemp = mkStmtOneInstr (Set (predTemp, zero, locUnknown)) in
		  let siteInfo = new InstrSiteInfo.c func location (Set (left, expr, location)) in
		  let cci_func = Lval (var (FindFunction.find "cbi_yield" file)) in
		  let cci_call = Call (Some(predTemp), cci_func, [integer siteId], location) in
		  let thump = tuples#addSiteInstrs siteInfo [cci_call] in

		  let orig = mkStmtOneInstr (Set(left,expr,location)) in
		  stmt.skind <- Block (mkBlock [orig;initTemp; thump; bump]);
		end;
	    end;
	    SkipChildren
	| _ -> 
	    DoChildren
    end
