open Cil


class visitor sites skipLog = object (self)
  inherit InsertSkipsVisitor.visitor sites skipLog
      
  method insertSkip skip statement =
    let statements = [statement; mkStmtOneInstr skip] in
    let block = Block (mkBlock statements) in
    let replace statement =
      statement.skind <- block;
      statement
    in
    ChangeDoChildrenPost (statement, replace)
end
