open Cil


class virtual visitor = object
  inherit CurrentFunctionVisitor.visitor

  method private makeTempVar name =
    Cil.makeTempVar !currentFunction ~name:name
end
