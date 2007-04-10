open Cil


let trackable = function
  | TInt _ -> true
  | _ -> false


class tracker fundec scope typ =
  let makeVar role =
    let name = fundec.svar.vname ^ scope ^ "$" ^ role in
    let var = makeGlobalVar name typ in
    var.vstorage <- Static;
    var
  in
  object
    val value = makeVar "value"
    val mask = makeVar "mask"

    method typ = typ

    method define =
      [ GVar (value, None, locUnknown);
	GVar (mask, Some (SingleInit (UnOp (BNot, zero, mask.vtype))), locUnknown) ]

    method update sample =
      let expr = Lval (var sample) in
      [ Set (var mask, BinOp (BAnd,
			      Lval (var mask),
			      UnOp (BNot,
				    BinOp (BXor,
					   Lval (var value),
					   expr,
					   typ),
				    typ),
			      typ),
	     locUnknown);
	Set (var value, expr, locUnknown) ]
  end


type factory = string -> typ -> tracker
