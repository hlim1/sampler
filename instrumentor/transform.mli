open Cil


val visit : Weighty.tester -> (fundec -> Countdown.countdown) -> (fundec * stmt list) -> unit
