open Cil


class visitor : Logger.builder -> fundec -> object
  inherit Sites.visitor
  method consider : stmtkind -> Sites.instrumentation
end
