open Cil
open Pretty
open Str


let isLocalCountdown =
  let pattern = regexp "^localEventCountdown[1-9][0-9]*$" in
  fun candidate ->
    string_match pattern candidate.vname 0


class printer =
  object (self)
    inherit defaultCilPrinterClass as super

    method pStmtKind next () = function
      |	If (BinOp (Gt, Lval (Var local, NoOffset), Const (CInt64 (_, IUInt, None)), intType) as predicate,
	    ({ battrs = []; bstmts = [{ skind = Goto _ }] } as original),
	    ({ battrs = []; bstmts = [{ skind = Goto _ }] } as instrumented),
	    location)
	  as skind
	  when isLocalCountdown local
	->
	  self#pLineDirective location
            ++ (align
                  ++ text "if"
                  ++ (align
			++ text " (__builtin_expect("
			++ self#pExp () predicate
			++ text ", 1)) "
			++ self#pBlock () original)
                  ++ chr ' '
                  ++ (align
			++ text "else "
			++ self#pBlock () instrumented)
                  ++ unalign)
      |	other ->
	  super#pStmtKind next () other
  end
