open Cil


class visitor sites countdown = object (self)
  inherit InsertSkipsVisitor.visitor sites countdown
      
  method insertSkip skip statement =
    [mkStmt statement.skind; mkStmtOneInstr skip]
end
