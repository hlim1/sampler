open Cil


val invariant : file -> fundec -> location -> varinfo -> exp -> global * stmt

val register : file -> unit
