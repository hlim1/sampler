open Cil
open Interesting
open Pretty


type direction = Min | Max


let updateBound best example direction location =
  let best = var best in
  let op = match direction with
  | Min -> Lt
  | Max -> Gt
  in
  If (BinOp (op, example, Lval best, intType),
      mkBlock [mkStmtOneInstr (Set (best, example, location))],
      mkBlock [],
      location)


let makeGlobals typ =
  let nextId = ref 0 in
  let prefix = "samplerBounds_" ^ (string_of_int !nextId) in
  (makeGlobalVar (prefix ^ "_min") typ,
   makeGlobalVar (prefix ^ "_max") typ)


class visitor global func =
  object (self)
    inherit SiteFinder.visitor

    val mutable globals = [global]
    method globals = globals

    method vstmt stmt =
      let build replacement left location _ =
	let leftType = typeOfLval left in
	let newLeft = var (Locals.makeTempVar func leftType) in
	let min, max = makeGlobals leftType in
	globals <- GVar (min, {init = None}, location) :: GVar (max, {init = None}, location) :: globals;
	Block (mkBlock [mkStmtOneInstr (replacement newLeft);
			mkStmt (updateBound min (Lval newLeft) Min location);
			mkStmt (updateBound max (Lval newLeft) Max location);
			mkStmtOneInstr (Set (left, Lval newLeft, location))])
      in

      match IsolateInstructions.isolated stmt with
      | Some (Set (left, expr, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Set (temp, expr, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | Some (Call (Some left, callee, args, location))
	when self#includedStatement stmt ->
	  begin
	    match isInterestingLval left with
	    | None -> ()
	    | Some info ->
		let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
		stmt.skind <- build replacement left location info;
	  end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
