open Cil


class visitor : object
  inherit Sites.visitor
  method consider : stmtkind -> instr option
end
