open Cil


type outputs = OutputSet.OutputSet.t

class map : [outputs] StmtMap.container

val collect : (stmtkind -> outputs) -> stmt list -> map
