open Cil
  

let skipLog =
  makeGlobalVar "skipLog" (TFun (TVoid [], Some [], false, []))

let call location =
  Call (None, Lval (var skipLog), [], location)
	
let addPrototype file =
  file.globals <- GVarDecl (skipLog, skipLog.vdecl) :: file.globals

let phase =
  "SkipLog",
  addPrototype
