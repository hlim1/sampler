open Cil
  

let voidConstPtrType = TPtr (voidType, [Attr ("const", [])])


let logWrite =
  makeGlobalVar "logWrite" (TFun (TVoid [],
				  Some [ "file", charConstPtrType, [];
					 "line", uintType, [];
					 "address", voidConstPtrType, [];
					 "size", uintType, [];
					 "data", voidPtrType, [] ],
				  false,
				  []))


let addPrototype file =
  file.globals <- GVarDecl (logWrite, logWrite.vdecl) :: file.globals
