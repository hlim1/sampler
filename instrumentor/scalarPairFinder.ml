open Cil
open Interesting
open Pretty


class visitor (constants : Constants.collection) globals (tuples : CounterTuples.manager) func =
  object (self)
    inherit SiteFinder.visitor

    val formals = List.filter isInterestingVar func.sformals
    val locals = List.filter isInterestingVar func.slocals

    method vstmt stmt =

      let build first left location =
	let leftType = typeOfLval left in
	let leftTypeSig = typeSig leftType in
	let leftDoc = (d_lval () left) ++ chr '\t' in

	let newLeft = var (Locals.makeTempVar func leftType) in
	let last = mkStmt (Instr [Set (left, Lval newLeft, location)]) in
	let statements = ref [last] in

	let selector right =
	  let compare op = BinOp (op, Lval newLeft, right, intType) in
	  BinOp (PlusA, compare Gt, compare Ge, intType)
	in

	let compareToVarMaybe right =
	  if left <> var right && leftTypeSig = typeSig right.vtype then
	    let selector = selector (Lval (var right)) in
	    let description = leftDoc ++ text right.vname in
	    let bump = tuples#addSite func selector description location in
	    statements := bump :: !statements
	in
	List.iter compareToVarMaybe globals;
	List.iter compareToVarMaybe formals;
	List.iter compareToVarMaybe locals;

	begin
	  let compareToConst right =
	    let selector = selector right in
	    let description = leftDoc ++ d_exp () right in
	    let bump = tuples#addSite func selector description location in
	    statements := bump :: !statements
	  in

	  let iterConsts signed =
	    let kind = if signed then ILongLong else IULongLong in
	    let action right () =
	      compareToConst (kinteger64 kind right)
	    in
	    constants#iter action
	  in

	  match unrollType leftType with
	  | TPtr _ ->
	      compareToConst (mkCast zero leftType)
	  | TInt (ikind, _) ->
	      iterConsts (isSigned ikind)
	  | TEnum _ ->
	      iterConsts true
	  | other ->
	      ignore (bug "unexpected left operand type: %a\n" d_type other)
	end;

	let first = mkStmtOneInstr (first newLeft) in
	Block (mkBlock (first :: !statements))
      in
      
      match IsolateInstructions.isolated stmt with
      | Some (Set (left, expr, location))
	when self#includedStatement stmt && isInterestingLval left ->
	  let replacement = (fun temp -> Set (temp, expr, location)) in
	  stmt.skind <- build replacement left location;
	  SkipChildren

      | Some (Call (Some left, callee, args, location))
	when self#includedStatement stmt && isInterestingLval left ->
	  let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
	  stmt.skind <- build replacement left location;
	  SkipChildren

      | _ ->
	  DoChildren
  end
