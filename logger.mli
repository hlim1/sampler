open Cil


type builder = location -> OutputSet.OutputSet.t -> global list ref -> instr list

val call : file -> builder
