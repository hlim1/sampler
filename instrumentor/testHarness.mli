open Cil


type phase = file -> unit

val doOne : phase list -> string -> unit
