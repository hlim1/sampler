open Cil


let vinfo =
  makeGlobalVar "nextLogCountdown" uintType
    
    
let lval = var vinfo


let addPrototype file =
  file.globals <- GVarDecl (vinfo, vinfo.vdecl) :: file.globals


let phase =
  "Countdown",
  addPrototype
