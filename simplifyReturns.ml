open Cil


let returnTypeOf typ =
  let (return, _, _, _) = splitFunctionType typ in
  return


class visitor = object
  inherit CurrentFunctionVisitor.visitor

  method vinst = function
    | Call (Some result, fname, actuals, location) ->
	begin
	  match result with
	  | (Var _, _) -> SkipChildren
	  | (Mem _, _) ->
	      let temp = var (makeTempVar !currentFunction ~name:"call" (returnTypeOf (typeOf fname))) in
	      ChangeTo [Call (Some temp, fname, actuals, location);
			Set (result, Lval temp, location)]
	end
    | _ -> SkipChildren
end


let phase _ =
  ("SimplifyReturns", visitCilFileSameGlobals new visitor)
