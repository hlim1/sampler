open Cil


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set ((Mem _, NoOffset), _, location) ->
	ChangeTo [SkipLog.call location; inst]
    | _ ->
	SkipChildren
end
