open Cil


class visitor file = object
  inherit [FindSites.sites] TransformVisitor.visitor file

  val logger = FindLogger.find file

  method findSites = FindSites.visit
  method insertSkips sites countdown = (new InsertSkipsBefore.visitor sites countdown :> cilVisitor)
  method insertLogs = Logs.insert logger
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
