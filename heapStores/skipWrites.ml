open Cil


class visitor skipLog = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    begin
      match inst with
      | Set ((Mem _, NoOffset), _, location) ->
	  self#queueInstr [skipLog location]
      | _ -> ()
    end;
    SkipChildren
end
