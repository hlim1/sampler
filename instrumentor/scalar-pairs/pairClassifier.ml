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
      match stmt.skind with
      | Instr [Set ((Var left, NoOffset), _, location)]
	when isInterestingVar left && self#includedStatement stmt ->
	  let bumps =

	    let build =
	      let leftOperand = {
		exp = Lval (var left);
		doc = text left.vname
	      } in
	      let bump = tuples#bump func location leftOperand in
	      fun right ->
		let rightOperand = {
		  exp = right;
		  doc = d_exp () right
		} in
		let site = mkStmt (bump rightOperand) in
		sites <- site :: sites;
		site
	    in

	    let rights =
	      let isComparable =
		let signature = typeSig left.vtype in
		fun right ->
		  left != right &&
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
		    match unrollType left.vtype with
		    | TPtr _ ->
			[mkCast zero left.vtype]
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

	  stmt.skind <- Block (mkBlock (mkStmt stmt.skind :: bumps));
	  SkipChildren

      | _ ->
	  super#vstmt stmt
  end
