open Cil


let skipCall location =
  Call (None, Lval (var SkipWrite.skipWrite), [], location)
	
	
class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set ((Mem _, NoOffset), _, location) ->
	ChangeTo [skipCall location; inst]
    | _ ->
	SkipChildren
end


let visit func =
  ignore (visitCilFunction new visitor func)
