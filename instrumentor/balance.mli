open Cil


type t

val prepatch : fundec -> t

val patch : t -> WeighPaths.weightsMap -> unit
