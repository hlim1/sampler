open Cil
  

let logWrite =
  makeGlobalVar "logWrite" (TFun (TVoid [],
				  Some [ "file", charConstPtrType, [];
					 "line", uintType, [];
					 "address", voidPtrType, [];
					 "size", uintType, [];
					 "data", voidPtrType, [] ],
				  false,
				  []))


let addPrototype file =
  file.globals <- GVarDecl (logWrite, logWrite.vdecl) :: file.globals
