open Cil


class builder : file ->
  object
    inherit Tuples.builder
    method bump : fundec -> location -> stmt -> exp -> lval * stmtkind
  end
