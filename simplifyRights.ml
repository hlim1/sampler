open Cil


class visitor initialFunction = object(self)
  inherit SimplifyVisitor.visitor initialFunction
      
  method vinst = function
    | Set ((Mem _, _) as lval, data, location) ->
	begin
	  match data with
	  | Lval (Var _, NoOffset) -> SkipChildren
	  | _ ->
	      let temp = var (self#makeTempVar "right" (typeOf data)) in
	      ChangeTo [Set (temp, data, location);
			Set (lval, Lval temp, location)]
	end
    | _ -> SkipChildren
end


let phase =
  "SimplifyRights",
  visitCilFileSameGlobals (new visitor dummyFunDec)
