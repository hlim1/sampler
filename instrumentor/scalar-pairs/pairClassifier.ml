open Cil
open DescribedExpression
open Interesting
open Pretty


class visitor file (constants : Constants.collection) (tuples : PairTuples.builder) func =
  object (self)
    inherit Classifier.visitor func as super

    val vars =
      let globalVars =
	let rec gather = function
	  | GVar (varinfo, _, _) :: rest
	  | GVarDecl (varinfo, _) :: rest
	    when isInterestingVar varinfo ->
	      varinfo :: gather rest
	  | GFun (through, _) :: _ when func == through ->
	      []
	  | _ :: rest ->
	      gather rest
	  | [] ->
	      failwith ("file contains no function " ^ func.svar.vname ^ "()")
	in
	gather file.globals
      in
      let localVars = List.filter isInterestingVar (func.sformals @ func.slocals) in
      globalVars @ localVars

    method vstmt stmt =
      let build replacement left location =

	let leftType = typeOfLval left in
	let newLeft = var (makeTempVar func leftType) in

	let bumps =

	  let build =
	    let leftOperand = {
	      exp = Lval newLeft;
	      doc = d_lval () left
	    } in
	    let bump = tuples#bump func location in
	    fun right ->
	      let rightOperand = {
		exp = right;
		doc = d_exp () right
	      } in
	      let site = mkEmptyStmt () in
	      let bump = bump site leftOperand rightOperand in
	      site.skind <- bump;
	      sites <- site :: sites;
	      site
	  in

	  let rights =
	    let isComparable =
	      let signature = typeSig leftType in
	      fun right ->
		left <> var right &&
		signature = typeSig right.vtype
	    in
	    let rec filter =
	      let flattenConstants signed =
		let kind = if signed then
		  ILongLong
		else
		  IULongLong
		in
		let folder number results =
		  kinteger64 kind number :: results
		in
		constants#fold folder []
	      in
	      function
		| right :: rights when isComparable right ->
		    Lval (var right) :: filter rights
		| _ :: rights ->
		    filter rights
		| [] ->
		    match unrollType leftType with
		    | TPtr _ ->
			[mkCast zero leftType]
		    | TInt (ikind, _) ->
			flattenConstants (isSigned ikind)
		    | TEnum _ ->
			flattenConstants true
		    | other ->
			ignore (bug "unexpected left operand type: %a\n" d_type other);
			[]
	    in
	    filter vars
	  in

	  List.map build rights
	in
	Block (mkBlock (mkStmt (Instr [replacement newLeft])
			:: bumps
			@ [mkStmt (Instr [Set (left, Lval newLeft, location)])]))
      in

      match stmt.skind with
      | Instr [Set (left, expr, location)]
	when self#includedStatement stmt && isInterestingLval left ->
	  let replacement = (fun temp -> Set (temp, expr, location)) in
	  stmt.skind <- build replacement left location;
	  SkipChildren

      | Instr [Call (Some left, callee, args, location)]
	when self#includedStatement stmt && isInterestingLval left ->
	  let replacement = (fun temp -> Call (Some temp, callee, args, location)) in
	  stmt.skind <- build replacement left location;
	  SkipChildren

      | Instr (_ :: _ :: _) ->
	  ignore (bug "instr should have been atomized");
	  failwith "internal error"

      | _ ->
	  DoChildren
  end
