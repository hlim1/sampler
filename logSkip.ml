open Cil
  

let logSkip =
  makeGlobalVar "logSkip" (TFun (TVoid [],
				 Some [],
				 false,
				 []))

let addPrototype file =
  file.globals <- GVarDecl (logSkip, logSkip.vdecl) :: file.globals

let phase =
  "LogSkip",
  addPrototype
