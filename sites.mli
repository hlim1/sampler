open Cil


class map : [instr] StmtMap.container


class virtual visitor : object
  inherit cilVisitor

  method virtual consider : stmtkind -> instr option
  method result : map
end
