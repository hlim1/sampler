open Cil


class visitor : Logger.builder -> object
  inherit Sites.visitor
  method consider : stmtkind -> Sites.instrumentation
end
