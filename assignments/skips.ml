open Cil


class visitor skipLog = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set (_, _, location)
    | Call (Some _, _, _, location) ->
	ChangeTo [inst; skipLog location]
    | _ ->
	SkipChildren
end
