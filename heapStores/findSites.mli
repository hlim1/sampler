open Cil


type map = (exp * lval * location) StmtMap.container
      
val visit : block -> map
