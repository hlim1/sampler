open Cil
  

let skipWrite =
  makeGlobalVar "skipWrite" (TFun (TVoid [], Some [], false, []))

let addPrototype file =
  file.globals <- GVarDecl (skipWrite, skipWrite.vdecl) :: file.globals

let phase =
  "SkipWrite",
  addPrototype
