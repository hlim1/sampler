open Cil


class visitor = object
  inherit TransformVisitor.visitor as super

  method weigh = Stores.count_stmt
  method insertSkips = new SkipWrites.visitor
  method insertLogs _ = new Instrument.visitor

  method vfunc func =
    Simplify.visit func;
    super#vfunc func
end


let phase =
  "Transform",
  visitCilFileSameGlobals (new visitor :> cilVisitor)
