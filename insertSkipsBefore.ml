open Cil


class visitor sites skipLog = object (self)
  inherit InsertSkipsVisitor.visitor sites skipLog
      
  method insertSkip skip _ =
    self#queueInstr [skip];    
    DoChildren
end
