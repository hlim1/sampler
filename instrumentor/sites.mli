open Cil


type info = Site.t list

val patch : ClonesMap.clonesMap -> Countdown.countdown -> stmt -> unit
