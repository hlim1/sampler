open Cil


type t

val addDefaultCases : file -> unit
val prepatch : fundec -> t
val patch : fundec -> t -> WeighPaths.weightsMap -> unit
