open Cil


let returnTypeOf typ =
  let (return, _, _, _) = splitFunctionType typ in
  return


class visitor = object(self)
  inherit SimplifyVisitor.visitor

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


let simplifyBlock block =
  ignore (visitCilBlock (new visitor) block)


let phase _ =
  ("SimplifyReturns", visitCilFileSameGlobals new visitor)
