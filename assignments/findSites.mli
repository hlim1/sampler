open Cil


class visitor : exp -> object
  inherit Sites.visitor
  method consider : stmtkind -> instr option
end
