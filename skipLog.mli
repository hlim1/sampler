open Cil


type closure = location -> instr

val find : file -> closure
