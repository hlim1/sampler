open Cil


class visitor file = object
  inherit [FindSites.map] TransformVisitor.visitor file as super

  method findSites = FindSites.visit
  method insertSkips sites countdown = (new InsertSkipsBefore.visitor sites countdown :> cilVisitor)
  method insertLogs _ = Instrument.insert

  method vfunc func =
    Simplify.visit func;
    super#vfunc func
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
