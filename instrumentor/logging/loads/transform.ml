class visitor file =
  object
    inherit TransformVisitor.visitor file

    method private collector _ = new Log.visitor file
  end


let phase =
  "Transform",
  fun file ->
    let visitor = new visitor file in
    Cil.visitCilFile visitor file
