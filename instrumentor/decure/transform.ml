open Cil


class visitor file =
  object
    inherit TransformVisitor.visitor file

    method private collector _ = new Find.visitor
  end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file) file
