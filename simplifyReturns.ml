open Cil


let returnTypeOf typ =
  let (return, _, _, _) = splitFunctionType typ in
  return


class visitor initialFunction = object(self)
  inherit SimplifyVisitor.visitor initialFunction

  method vinst = function
    | Call (Some result, fname, actuals, location) ->
	begin
	  match result with
	  | (Var _, _) -> SkipChildren
	  | (Mem _, _) ->
	      let temp = var (self#makeTempVar "call" (returnTypeOf (typeOf fname))) in
	      ChangeTo [Call (Some temp, fname, actuals, location);
			Set (result, Lval temp, location)]
	end
    | _ -> SkipChildren
end


let phase =
  "SimplifyReturns",
  visitCilFileSameGlobals (new visitor dummyFunDec)
