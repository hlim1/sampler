open Cil


class visitor file = object
  inherit TransformVisitor.visitor file
      
  method collectOutputs _ = FindSites.collect
  method placeInstrumentation code log = code :: log
end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file :> cilVisitor) file
