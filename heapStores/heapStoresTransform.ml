open Cil


class visitor file = object
  inherit TransformVisitor.visitor file as super

  method collectOutputs _ = FindSites.collect
  method placeInstrumentation code log = log @ [code]

  method instrumentFunction func =
    Simplify.visit func;
    super#instrumentFunction func
end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file :> cilVisitor) file
