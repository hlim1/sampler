open Cil


type weightsMap = int StmtMap.container

val weigh : stmt list -> weightsMap option
