open Cil


class visitor file = object
  inherit TransformVisitor.visitor file

  val logger = FindLogger.find file

  method weigh = Weigh.weigh
  method insertSkips = new Skips.visitor
  method insertLogs = new Logs.visitor logger
end


let phase =
  "Transform",
  fun file -> visitCilFileSameGlobals (new visitor file :> cilVisitor) file
