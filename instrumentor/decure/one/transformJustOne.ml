open Cil


let foundTarget = ref false


class visitor = Transform.visitor


let phase =
  "Transform",
  fun file ->
    visitCilFile (new visitor file) file;
    assert !foundTarget
