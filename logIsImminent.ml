open Cil
  

let logIsImminent =
  makeGlobalVar "logIsImminent" (TFun (intType,
				       Some [ "within", uintType, [] ],
				       false,
				       []))


let addPrototype file =
  file.globals <- GVarDecl (logIsImminent, logIsImminent.vdecl) :: file.globals
