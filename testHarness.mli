open Cil

type phase = string * (file -> unit)

val main : phase list -> unit
