open Cil


type builder = location -> OutputSet.OutputSet.t -> instr list

val call : file -> builder
