open Cil


class visitor file =
  object
    inherit TransformVisitor.visitor file

    method private collector _ = new Find.visitor
    method private prepatchCalls = DecureCalls.prepatch
  end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file) file
