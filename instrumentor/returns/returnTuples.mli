open Cil
open Pretty


class builder : file ->
  object
    inherit Tuples.builder
    method bump : fundec -> location -> exp -> doc -> stmtkind
  end
