open Cil


class virtual visitor sites countdown = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method virtual insertSkip : instr -> stmt -> stmt list

  method vstmt statement =
    if statement.sid != -1 && sites#mem statement then
      let replacements = self#insertSkip (countdown#decrement (Where.statement statement)) statement in
      let block = Block (mkBlock replacements) in
      let replace stmt =
	stmt.skind <- block;
	stmt
      in
      ChangeDoChildrenPost (statement, replace)
    else
      DoChildren
end
