open Cil
open Interesting
open Pretty
open ScalarPairSiteInfo
open MustBeUninitialized


let compareUninitialized =
  Options.registerBoolean
    ~flag:"compare-uninitialized"
    ~desc:"consider uninitialized variables in scalar-pairs comparisons"
    ~ident:"CompareUninitialized"
    ~default:false


let d_columns = seq ~sep:(chr '\t') ~doit:(fun doc -> doc)


let isInterestingVar  = isInterestingVar  isDiscreteType
let isInterestingLval = isInterestingLval isDiscreteType


class visitor (constants : Constants.collection) globals (tuples : Counters.manager) func =
  object (self)
    inherit SiteFinder.visitor

    val formals = List.filter isInterestingVar func.sformals
    val locals = List.filter isInterestingVar func.slocals
    val isAssignedFunc = ref (fun _ _ -> true)

    method vfunc func =
      Cfg.build func;
      if not !compareUninitialized then
	isAssignedFunc := computeUninitialized func locals;
      DoChildren

    method vstmt stmt =

      let build first left location (host, off) =
	let leftType = typeOfLval left in
	let leftTypeSig = typeSig leftType in
	let siteInfo = new ScalarPairSiteInfo.c func location (left, host, off) in

	let newLeft = var (Locals.makeTempVar func leftType) in
	let last = mkStmt (Instr [Set (left, Lval newLeft, location)]) in
	let statements = ref [last] in

	let selector right =
	  let compare op = BinOp (op, Lval newLeft, right, intType) in
	  Index (BinOp (PlusA, compare Gt, compare Ge, intType), NoOffset)
	in

	let compareToVarMaybe right =
	  if leftTypeSig = typeSig right.vtype then
	    let selector = selector (Lval (var right)) in
	    let siteInfo = siteInfo (Variable right) in
	    let bump = tuples#addSite siteInfo selector in
	    statements := bump :: !statements
	in
	List.iter compareToVarMaybe globals;
	List.iter compareToVarMaybe formals;
	List.iter compareToVarMaybe (List.filter (!isAssignedFunc stmt) locals);

	begin
	  let compareToConst right =
	    let selector = selector right in
	    let siteInfo = siteInfo (Constant right) in
	    let bump = tuples#addSite siteInfo selector in
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
