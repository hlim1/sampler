open Cil


type builder = location -> label


val build : string -> builder

val hasGotoLabel : stmt -> bool
val ensureHasGotoLabel : stmt -> builder -> unit
