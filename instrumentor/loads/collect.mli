open Cil
open OutputSet


val collect : (cilVisitor -> 'root -> _) -> 'root -> OutputSet.t
