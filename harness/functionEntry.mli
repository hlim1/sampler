open Cil


val find : fundec -> stmt

val patch : fundec -> WeighPaths.weightsMap -> Countdown.countdown -> block -> unit
