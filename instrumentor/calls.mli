open Cil


type placeholders = stmt list

val prepatch : fundec -> placeholders
val patch : ClonesMap.clonesMap -> WeighPaths.weightsMap -> Countdown.countdown -> placeholders -> unit
val postpatch : ClonesMap.clonesMap -> Countdown.countdown -> placeholders -> unit
