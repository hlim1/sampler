open Cil


let bump func =
  let lt = var (makeTempVar func intType) in
  let le = var (makeTempVar func intType) in

  fun location left right counters ->
    let offset : offset = Index (BinOp (PlusA,
					Lval lt,
					Lval le,
					intType),
				 NoOffset) in
    let counter = addOffsetLval offset counters in

    mkStmt (Instr
	      [ Asm ([],
		     [ "xor %0,%0";
		       "xor %1,%1";
		       "cmp %2,%3";
		       "setge %b0";
		       "setg %b1" ],
		     [ "=r,r", lt;
		       "=r,r", le ],
		     [ "r,g", Lval (var left);
		       "g,r", right],
		     [ "cc" ],
		     location);
		Set (counter, increm (Lval counter) 1, location) ])
