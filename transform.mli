open Cil


val transform : (stmt -> int) -> cilVisitor -> cilVisitor -> fundec -> unit
