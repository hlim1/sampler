open Cil


class visitor = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    begin
      match inst with
      | Set ((Mem _, NoOffset), _, location) ->
	  self#queueInstr [SkipLog.call location]
      | _ -> ()
    end;
    SkipChildren
end
