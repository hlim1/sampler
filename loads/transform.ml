open Cil


class visitor file = object
  inherit TransformVisitor.visitor file

  method findSites _ = new FindSites.visitor logger
  method placeInstrumentation code log = log @ [code]
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
