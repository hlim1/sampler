open Cil


val find : fundec -> stmt

val patch : fundec -> WeighPaths.weightsMap -> exp -> block -> unit
