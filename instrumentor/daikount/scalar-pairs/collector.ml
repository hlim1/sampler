open Cil
open Invariant


let isInteresting =
  let hasInterestingType varinfo =
    isIntegralType varinfo.vtype || isPointerType varinfo.vtype
  in

  let hasInterestingNameLocal varinfo =
    let regexp =
      let pattern =
	let names = ["tmp"; "__result";
		     "__s";
		     "__s1"; "__s1_len";
		     "__s2"; "__s2_len";
		     "__u";
		     "__c"] in
	let alpha = "\\(___[0-9]+\\)?" in
	"\\(" ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
      in
      Str.regexp pattern
    in
    not (Str.string_match regexp varinfo.vname 0)
  in

  let hasInterestingNameGlobal varinfo =
    let uninteresting = [
      "sys_nerr";
      "gdk_debug_level"; "gdk_show_events"; "gdk_stack_trace"
    ] in
    not (List.mem varinfo.vname uninteresting)
  in

  fun varinfo ->
    if hasInterestingType varinfo then
      let hasInterestingName = if varinfo.vglob then
	hasInterestingNameGlobal
      else
	hasInterestingNameLocal
      in
      hasInterestingName varinfo
    else
      false


class visitor file =
  let invariant = invariant file in

  fun global func ->
    let invariant = invariant func in

    object (self)
      inherit Classifier.visitor global as super

      val mutable sites = []
      method sites = sites

      val vars =
	let globalVars =
	  let rec gather = function
	    | GVar (varinfo, _, _) :: rest
	    | GVarDecl (varinfo, _) :: rest
	      when isInteresting varinfo ->
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
		  let (site, global) = invariant rightOperand in
		  let site = mkStmt site in
		  sites <- site :: sites;
		  self#addGlobal global;
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
