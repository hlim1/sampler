open Cil


class visitor = object
  inherit CurrentFunctionVisitor.visitor

  method vinst = function
    | Set ((Mem _, _) as lval, data, location) ->
	begin
	  match data with
	  | Lval (Var varinfo, NoOffset) -> SkipChildren
	  | _ ->
	      let temp = var (makeTempVar !currentFunction ~name:"right" (typeOf data)) in
	      ChangeTo [Set (temp, data, location);
			Set (lval, Lval temp, location)]
	end
    | _ -> SkipChildren
end


let phase _ =
  ("SimplifyRights", visitCilFileSameGlobals new visitor)
