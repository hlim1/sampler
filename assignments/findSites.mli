open Cil


type sites = (lval * location) StmtMap.container
      
val visit : block -> sites
