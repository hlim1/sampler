open Cil


class visitor = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set (_, _, location)
    | Call (Some _, _, _, location) ->
	ChangeTo [inst; SkipLog.call location]
    | _ ->
	SkipChildren
end
