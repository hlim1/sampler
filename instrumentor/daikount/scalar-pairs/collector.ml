open Cil
open Invariant


let isInteresting varinfo =
  let hasInterestingName () =
    let regexp =
      let pattern =
	let names = ["tmp"] in
	let alpha = "\\(___[0-9]+\\)?" in
	"\\(" ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
      in
      Str.regexp pattern
    in
    not (Str.string_match regexp varinfo.vname 0)
  in

  let hasInterestingType () =
    isIntegralType varinfo.vtype || isPointerType varinfo.vtype
  in

  hasInterestingType () && hasInterestingName()


class visitor file =
  let invariant = invariant file in

  fun func ->
    let invariant = invariant func in

    object
      inherit FunctionBodyVisitor.visitor

      val mutable sites = []
      method result = sites

      val vars =
	let globalVars =
	  let rec gather = function
	    | GVar (varinfo, _, _) :: rest
	    | GVarDecl (varinfo, _) :: rest
	      when varinfo.vname <> "sys_nerr" ->
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
	let localVars = List.filter isInteresting (func.sformals @ func.slocals) in
	globalVars @ localVars

      method vstmt stmt =
	match stmt.skind with
	| Instr [Set ((Var left, NoOffset), _, location)]
	  when isInteresting left ->
	    let bumps =

	      let build =
		let leftOperand = {
		  exp = Lval (var left);
		  name = left.vname
		} in
		let invariant = invariant location leftOperand in
		fun right ->
		  let rightOperand = {
		    exp = right;
		    name = Pretty.sprint max_int (d_exp () right)
		  } in
		  let (stmt, _) as site = invariant rightOperand in
		  sites <- site :: sites;
		  stmt
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

	| Instr (_ :: _ :: _) as instr ->
	    currentLoc := get_stmtLoc instr;
	    ignore (bug "instr should have been atomized");
	    SkipChildren

	| _ ->
	    DoChildren
    end


let collect file =
  let visitor = new visitor file in
  fun func ->
    let visitor = visitor func in
    ignore (visitCilFunction (visitor :> cilVisitor) func);
    visitor#result
