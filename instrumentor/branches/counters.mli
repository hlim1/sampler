open Cil


val build : file -> fundec -> location -> exp -> lval * stmtkind * global

val register : file -> unit
