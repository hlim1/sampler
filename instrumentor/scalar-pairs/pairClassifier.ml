open Cil
open DescribedExpression
open Interesting
open Pretty


class visitor file (tuples : PairTuples.builder) func =
  object (self)
    inherit Classifier.visitor as super

    val mutable sites = []
    method sites = sites

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
	      let rec filter = function
		| right :: rights when isComparable right ->
		    Lval (var right) :: filter rights
		| _ :: rights ->
		    filter rights
		| [] ->
		    if isPointerType left.vtype then
		      [mkCast zero left.vtype]
		    else
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
