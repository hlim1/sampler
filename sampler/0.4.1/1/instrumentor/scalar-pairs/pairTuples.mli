open Cil
open Pretty


class builder : file ->
  object
    inherit Tuples.builder
    method bump : fundec -> location -> DescribedExpression.t -> DescribedExpression.t -> stmtkind
  end
