open Cil


let skipCall location =
  Call (None, Lval (var LogSkip.logSkip), [], location)
	
	
class visitor = object(self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set ((Mem _, _), _, location) ->
	ChangeTo [skipCall location; inst]
    | _ ->
	SkipChildren
end


let visit func =
  ignore (visitCilFunction new visitor func)
