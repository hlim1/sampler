open Cil


val collect : (cilVisitor -> 'root -> 'result) -> 'root -> OutputSet.OutputSet.t
