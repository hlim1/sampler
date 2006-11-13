open Cil


type bumper = Tuples.siteId -> exp -> location -> instr

val build : file -> bumper
