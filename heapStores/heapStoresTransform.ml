open Cil


class visitor file = object
  inherit TransformVisitor.visitor file as super

  method collectOutputs _ = FindSites.collect
  method placeInstrumentation code log = log @ [code]

  method vfunc func =
    Simplify.visit func;
    super#vfunc func
end


let phase =
  "Transform",
  fun file ->
    visitCilFileSameGlobals (new visitor file :> cilVisitor) file
