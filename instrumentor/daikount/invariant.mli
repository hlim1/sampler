open Cil


val invariant : file -> fundec -> location -> lval -> exp -> global * stmt

val register : file -> unit
