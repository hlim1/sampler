open Cil


type phase = string * (file -> unit)

val time : string -> (unit -> 'a) -> 'a

val doOne : phase list -> string -> unit
