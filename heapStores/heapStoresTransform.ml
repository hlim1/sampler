open Cil


class visitor file = object
  inherit TransformVisitor.visitor file as super

  method findSites _ = new FindSites.visitor
  method placeInstrumentation code log = [log; code]

  method vfunc func =
    Simplify.visit func;
    super#vfunc func
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
