open Cil


class visitor initialFunction = object(self)
  inherit SimplifyVisitor.visitor initialFunction

  method vinst = function
    | Set ((Mem(expr), offset) as lval, data, location) ->
	begin
	  match (expr, offset) with
	  | (Lval (Var _, NoOffset), NoOffset) ->
	      SkipChildren
	  | _ ->
	      let addr = mkAddrOf lval in
	      let temp = var (self#makeTempVar "left" (typeOf addr)) in
	      let mem = mkMem (Lval temp) NoOffset in
	      ChangeTo [Set (temp, addr, location);
			Set (mem, data, location)]
	end
    | _ -> SkipChildren
end


let simplifyBlock func block =
  ignore (visitCilBlock (new visitor func) block)


let phase _ =
  ("SimplifyLefts", visitCilFileSameGlobals (new visitor dummyFunDec))
