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
	      let temp = var (self#makeTempVar "call" (typeOfLval result)) in
	      ChangeTo [Call (Some temp, fname, actuals, location);
			Set (result, Lval temp, location)]
	end
    | _ -> SkipChildren
end


let phase =
  "SimplifyReturns",
  visitCilFileSameGlobals new visitor
