open Cil
open Str


let isCheck =
  let pattern = regexp "__CHECK_" in
  fun candidate -> string_match pattern candidate 0


type classification = Check | Fail | Generic


let classifyByName = function
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


let classifyStatement = function
  | Instr [Call (None, Lval (Var {vname = vname}, NoOffset), _, location)] ->
      classifyByName vname

  | If (p,
	{ battrs = [];
	  bstmts = [
	  { skind = If (BinOp (Shiftrt,
			       BinOp (MinusPP,
				      Lval (Var _, NoOffset),
				      CastE (TPtr (TInt (IChar, []), []), p'),
				      TInt (IInt, [])),
			       Const (CInt64 (twentyOne, IInt, _)),
			       TInt (IInt, [])),
			{ battrs = []; bstmts = [] },
			{ battrs = []; bstmts = [
			  { skind = Instr [ Call (None, Lval (Var {vname = "fp_fail"},
							      NoOffset),
						  [ Const (CInt64 (zero, IInt, _));
						    Const (CStr _);
						    Const (CInt64 (_, IInt, _)) ],
						  _) ] } ] },
			_) } ] },
	{ battrs = []; bstmts = [] },
	_)
    when twentyOne = Int64.of_int 21
	&& zero = Int64.zero
	&& p = p'
    ->
      (* CHECK_RETURNPTR *)
      Check

  | _ ->
      Generic
