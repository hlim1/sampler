open Cil


val addScheme : (file -> Scheme.c) -> unit

val phase : string * (file -> unit)
