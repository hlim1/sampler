open Cil


class builder : file ->
  object
    method bump : fundec -> location -> exp -> lval * stmtkind
    method register : unit
  end
