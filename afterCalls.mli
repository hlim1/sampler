open Cil


val split : fundec -> stmt list

val patch : Duplicate.clonesMap -> WeighPaths.weightsMap -> exp -> stmt list -> unit
