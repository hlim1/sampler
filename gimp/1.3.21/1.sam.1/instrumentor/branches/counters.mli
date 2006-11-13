open Cil


class builder : file ->
  object
    inherit Tuples.builder
    method bump : fundec -> location -> exp -> lval * stmtkind
  end
