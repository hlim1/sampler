open Cil


type map = (lval * location) StmtMap.container
      
val visit : block -> map
