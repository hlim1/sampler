open Cil


class visitor : exp -> fundec -> object
  inherit Sites.visitor
  method consider : stmtkind -> instr option
end
