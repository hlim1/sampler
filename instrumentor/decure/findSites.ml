open Cil
open Str


let checkPattern = regexp "^__CHECK_"


let isCheck = function
  | "__CHECK_STOREPTR"
  | "__CHECK_FUNTIONPOINTER"
  | "__CHECK_FSEQ2SAFE"
  | "__CHECK_FSEQALIGN"
  | "__CHECK_SEQALIGN"
  | "__CHECK_SEQ2SAFE"
  | "__CHECK_BOUNDS_LEN"
  | "__CHECK_INDEXALIGN"
  | "__CHECK_GEU"
  | "__CHECK_SEQ2FSEQ"
  | "__CHECK_POSITIVE"
  | "__CHECK_FSEQARITH"
  | "__CHECK_FSEQARITH2SAFE"
  | "__CHECK_NULL"
  | "__CHECK_RTTICAST"
  | "__CHECK_WILDPOINTERREAD"
  | "__CHECK_WILDPOINTERWRITE_NOSTACKCHECK"
  | "__CHECK_WILDPOINTERWRITE"
  | "__CHECK_WILDP_WRITE_ATLEAST" ->
      true
  | _ ->
      false


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  val mutable checks = []
  method result = checks

  method vfunc func =
    if isCheck func.svar.vname then
      SkipChildren
    else
      DoChildren

  method vstmt stmt =
    begin
      match stmt.skind with
	(* !!!: CHECK_RETURNPTR not yet handled *)
      | Instr (_ :: _ :: _) ->
	  currentLoc := get_stmtLoc stmt.skind;
	  ignore (bug "non-singleton Instr")

      | Instr [Call (None, Lval (Var {vname = vname}, NoOffset), _, location)] ->
	  if isCheck vname then
	    checks <- stmt :: checks
	  else if string_match checkPattern vname 0 then
	    begin
	      currentLoc := get_stmtLoc stmt.skind;
	      ignore (warn "suspicious non-check call: %s\n" vname)
	    end

      | _ -> ()
    end;
    DoChildren
  end


let findSites func =
  let visitor = new visitor in
  ignore (visitCilFunction (visitor :> cilVisitor) func);
  visitor#result
