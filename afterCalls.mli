open Cil


val split : fundec -> stmt list

val patch : ClonesMap.clonesMap -> WeighPaths.weightsMap -> exp -> stmt list -> unit
