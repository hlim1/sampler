open Cil
open Pretty


class builder : file ->
  object
    inherit Tuples.builder
    method bump : fundec -> location -> stmt -> DescribedExpression.t -> DescribedExpression.t -> stmtkind
  end
