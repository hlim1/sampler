open Cil
open Interesting
open Pretty
open ScalarPairSiteInfo


let d_columns = seq ~sep:(chr '\t') ~doit:(fun doc -> doc)


type classifier = fundec -> exp -> location -> (exp * stmt)


let classifier file =
  let callee = Lval (var (FindFunction.find "cbi_floatKindsClassify" file)) in
  fun fundec value location ->
    let classification = var (Locals.makeTempVar fundec ~name:"floatKind" uintType) in
    let classifier = mkStmtOneInstr (Call (Some classification, callee, [value], location)) in
    (Lval classification, classifier)


class visitor (classifier : classifier) (tuples : Counters.manager) func =
  let classifier = classifier func in

  let classifyAndBump location left right =
    let (classification, classify) = classifier right location in
    let siteInfo = new FloatKindSiteInfo.c func location left in
    let bump, _ = tuples#addSiteExpr siteInfo classification in
    bump.skind <- Block (mkBlock [classify; mkStmt bump.skind]);
    bump
  in

  object (self)
    inherit SiteFinder.visitor

    method! vfunc func =
      if self#includedFunction func then
	let body =
	  let testFormal body formal =
	    if isInterestingVar isFloatType formal then
	      let location = formal.vdecl in
	      let lval = var formal in
	      let bump = classifyAndBump location (lval, "local", "direct") (Lval lval) in
	      bump :: body
	    else
	      body
	  in
	  mkBlock (List.fold_left testFormal [mkStmt (Block func.sbody)] func.sformals)
	in
	ChangeDoChildrenPost (func, fun func -> func.sbody <- body; func)
      else
	SkipChildren

    method! vstmt stmt =

      let build first left location (host, off) =
	let leftType = typeOfLval left in
	let newLeft = var (Locals.makeTempVar func leftType) in
	let newLeftVal = Lval newLeft in
	let first = mkStmtOneInstr (first newLeft) in
	let last = mkStmt (Instr [Set (left, newLeftVal, location)]) in

	let bump = classifyAndBump location (left, host, off) newLeftVal in
	Block (mkBlock [first; bump; last])
      in

      match IsolateInstructions.isolated stmt with
      | Some (Set (left, expr, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval isFloatType left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Set (temp, expr, location)) in
		stmt.skind <- build replacement left location info
	  end;
	  SkipChildren

      | Some (Call (Some left, callee, args, location)) ->
	  begin
	    match isInterestingLval isFloatType left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
		stmt.skind <- build replacement left location info
	  end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
