open Cil


type info = stmt list * global list

val patch : ClonesMap.clonesMap -> Countdown.countdown -> stmt -> unit
