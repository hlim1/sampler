open Cil


class visitor skipLog = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set (_, _, location)
    | Call (_, _, _, location)
    | Asm (_, _, _, _, _, location) ->
	self#queueInstr [skipLog location];
	SkipChildren
end
