open Cil


class visitor skipLog = object (self)
  inherit FunctionBodyVisitor.visitor as super
      
  method vstmt _ = DoChildren

  method vinst instr =
    super#queueInstr [skipLog (Where.locationOf instr)];
    SkipChildren
end
