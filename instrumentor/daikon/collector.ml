open Cil
open Pretty


let isInteresting varinfo =
  let regexp =
    let pattern =
      let names = ["tmp"] in
      let alpha = "\\(___[0-9]+\\)?" in
      "\\(" ^ (String.concat "\\|" names) ^ "\\)" ^ alpha ^ "$"
    in
    Str.regexp pattern
  in
  not (Str.string_match regexp varinfo.vname 0)


let d_var () varinfo =
  chr '<' ++
    text varinfo.vname ++
    text " : " ++
    d_type () varinfo.vtype ++
    chr '>'


let d_vars =
  d_list ", " d_var


class visitor file =
  let logger = Lval (var (FindFunction.find "checkInvariant" file)) in
  let invariants = Invariants.propose file in

  fun global func ->
    object
      inherit Classifier.visitor global

      val mutable sites = []
      method sites = sites

      val vars =
	let globals =
	  let rec gather = function
	    | GVar (varinfo, _, _) :: rest
	    | GVarDecl (varinfo, _) :: rest ->
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
	let locals = List.filter isInteresting (func.sformals @ func.slocals) in
	globals @ locals

      method vstmt stmt =
	match stmt.skind with
	| Instr [Set ((Var varinfo, NoOffset), _, location)]
	  when isInteresting varinfo ->
	    (* ignore (eprintf "%a: assignment to %a@!"
		      d_loc location
		      d_var varinfo); *)

	    (* ignore (eprintf "  vars in scope: %a@!" d_vars vars); *)

	    let signature = typeSig varinfo.vtype in
	    let isComparable other =
	      varinfo != other &&
	      signature = typeSig other.vtype
	    in
	    let comparableVars = List.filter isComparable vars in
	    (* ignore (eprintf "  comparable vars: %a@!" d_vars comparableVars); *)

	    let invariants = invariants signature varinfo comparableVars in
	    (* ignore (eprintf "  invariants: %a@!"
		      (d_list ", " d_exp) invariants); *)

	    let calls =
	      let callLogger invariant =
		let call = mkStmtOneInstr (Call (None, logger,
						 [mkString (sprint max_int (d_loc () location));
						  mkString func.svar.vname;
						  mkString (sprint max_int (d_exp () invariant));
						  invariant],
						 location))
		in
		sites <- call :: sites;
		call
	      in
	      List.map callLogger invariants
	    in
	    
	    stmt.skind <- Block (mkBlock (mkStmt stmt.skind :: calls));
	    SkipChildren

	| Instr (_ :: _ :: _) as instr ->
	    currentLoc := get_stmtLoc instr;
	    ignore (bug "instr should have been atomized");
	    SkipChildren

	| _ ->
	    DoChildren
    end
