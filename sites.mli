open Cil


type instrumentation = instr list

class map : [instrumentation] StmtMap.container


class virtual visitor : object
  inherit cilVisitor

  method virtual consider : stmtkind -> instrumentation
  method result : map
end
