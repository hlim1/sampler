open Cil


class virtual visitor sites skipLog = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method virtual insertSkip : instr -> stmt -> stmt visitAction

  method vstmt statement =
    if statement.sid != -1 && sites#mem statement then
      self#insertSkip (skipLog (Where.statement statement)) statement
    else
      DoChildren
end
