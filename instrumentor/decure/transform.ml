open Cil
open Classify


class visitor file =
  object
    inherit TransformVisitor.visitor file as super

    method private collector _ = new Find.visitor
    method private prepatchCalls = DecureCalls.prepatch
    method private shouldTransform = Should.shouldTransform
  end


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file) file
