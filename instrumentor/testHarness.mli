open Cil


type phase = string * (file -> unit)

val doOne : phase list -> string -> unit
