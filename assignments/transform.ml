open Cil


class visitor file = object
  inherit [FindSites.set] TransformVisitor.visitor file
      
  val logger = FindLogger.find file

  method findSites = FindSites.visit
  method insertSkips sites countdown = (new InsertSkipsAfter.visitor sites countdown :> cilVisitor)
  method insertLogs = new Logs.visitor logger
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
