open Cil
open Interesting
open Pretty
open ScalarPairSiteInfo


let d_columns = seq ~sep:(chr '\t') ~doit:(fun doc -> doc)


type classifier = fundec -> lval * (exp -> location -> instr)


let classifier file =
  let callee = Lval (var (FindFunction.find "floatKindsClassify" file)) in
  fun fundec ->
    let classification = var (Locals.makeTempVar fundec ~name:"floatKind" uintType) in
    (classification,
     fun value location ->
       Call (Some classification, callee, [value], location))


class visitor (classifier : classifier) (tuples : Counters.manager) func =
  let classification, classifier = classifier func in
  object (self)
    inherit SiteFinder.visitor

    method vstmt stmt =

      let build first left location (host, off) =
	let leftType = typeOfLval left in
	let newLeft = var (Locals.makeTempVar func leftType) in
	let newLeftVal = Lval newLeft in
	let first = mkStmtOneInstr (first newLeft) in
	let last = mkStmt (Instr [Set (left, newLeftVal, location)]) in

	let classify = mkStmtOneInstr (classifier newLeftVal location) in
	let siteInfo = new FloatKindSiteInfo.c func location (left, host, off) in
	let selector = Index (Lval classification, NoOffset) in
	let bump = tuples#addSite siteInfo selector in
	
	Block (mkBlock [first; classify; bump; last])
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
