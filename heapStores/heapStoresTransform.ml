open Cil


class visitor file = object
  inherit [FindSites.set] TransformVisitor.visitor file as super

  method findSites = FindSites.visit
  method insertSkips sites countdown = (new InsertSkipsBefore.visitor sites countdown :> cilVisitor)
  method insertLogs = new Instrument.visitor

  method vfunc func =
    Simplify.visit func;
    super#vfunc func
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
