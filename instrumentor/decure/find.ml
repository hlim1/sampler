open Cil
open Str


let checkPattern = regexp "^__CHECK_"


type classification = Check | Fail | Generic

let classify = function
  | "__CHECK_BOUNDS_LEN"
  | "__CHECK_FSEQ2SAFE"
  | "__CHECK_FSEQALIGN"
  | "__CHECK_FSEQARITH"
  | "__CHECK_FSEQARITH2SAFE"
  | "__CHECK_FUNCTIONPOINTER"
  | "__CHECK_GEU"
  | "__CHECK_INDEXALIGN"
  | "__CHECK_NULL"
  | "__CHECK_POSITIVE"
  | "__CHECK_RTTICAST"
  | "__CHECK_SEQ2FSEQ"
  | "__CHECK_SEQ2SAFE"
  | "__CHECK_SEQALIGN"
  | "__CHECK_STOREPTR"
  | "__CHECK_STRINGMAX"
  | "__CHECK_WILDPOINTERREAD"
  | "__CHECK_WILDPOINTERWRITE"
  | "__CHECK_WILDPOINTERWRITE_NOSTACKCHECK"
  | "__CHECK_WILDP_WRITE_ATLEAST" ->
      Check
  | "fp_fail"
  | "lbound_or_ubound_fail"
  | "ubound_or_non_pointer_fail" ->
      Fail
  | _ ->
      Generic


class visitor =
  object
    inherit FunctionBodyVisitor.visitor

    val mutable sites = []
    method sites = sites
    method globals : global list = []

    method vfunc func =
      match classify func.svar.vname with
      | Check
      | Fail ->
	  SkipChildren
      | Generic ->
	  DoChildren

    method vstmt ({skind = skind} as stmt) =
      match skind with
      | Instr [Call (None, Lval (Var {vname = vname}, NoOffset), _, location)] ->
	  begin
	    match classify vname with
	    | Check ->
		sites <- stmt :: sites;
	    | Fail ->
		currentLoc := get_stmtLoc skind;
		ignore (bug "found raw failure call; missed containing check?");
	    | Generic ->
		if string_match checkPattern vname 0 then
		  begin
		    currentLoc := get_stmtLoc skind;
		    ignore (warn "suspicious non-check call: %s\n" vname)
		  end
	  end;
	  SkipChildren

      | Instr [_]
      | Instr [] ->
	  SkipChildren

      | Instr _ ->
	  currentLoc := get_stmtLoc skind;
	  ignore (bug "non-singleton Instr");
	  SkipChildren

      | If (Lval (Var p, NoOffset),
	    { battrs = [];
	      bstmts = [
	      { skind = If (BinOp (Shiftrt,
				   BinOp (MinusPP,
					  Lval (Var _, NoOffset),
					  Lval (Var p', NoOffset),
					  TInt (IInt, [])),
				   Const (CInt64 (twentyOne, IInt, _)),
				   TInt (IInt, [])),
			    { battrs = []; bstmts = [] },
			    { battrs = []; bstmts = [
			      { skind = Block { battrs = [];
						bstmts = [
						{ skind = Instr [
						  Call (_, Lval (Var {vname = "fp_fail"},
								 NoOffset),
							Const (CInt64 (zero, IInt, _)) :: _,
							_) ] };
						{ skind = Instr [] } ] } } ] },
			    _) } ] },
	    { battrs = []; bstmts = [] },
	    _)
	when twentyOne = Int64.of_int 21
	    && zero = Int64.zero
	    && p == p'
	->
	  (* CHECK_RETURNPTR *)
	  sites <- stmt :: sites;
	  SkipChildren

      | _ ->
	  DoChildren
  end
