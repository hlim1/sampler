open Cil


type weightsMap = int StmtMap.container

val weigh : (stmt -> int) -> stmt list -> weightsMap option
