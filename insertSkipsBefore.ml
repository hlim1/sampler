open Cil


class visitor sites skipLog = object (self)
  inherit InsertSkipsVisitor.visitor sites skipLog
      
  method insertSkip skip statement =
    let statements = [mkStmtOneInstr skip; mkStmt statement.skind] in
    let block = Block (mkBlock statements) in
    let replace stmt =
      stmt.skind <- block;
      stmt
    in
    ChangeDoChildrenPost (statement, replace)
end
