open Cil
  

let logWrite =
  let f = emptyFunction "logWrite" in
  let arg name typ = ignore (makeFormalVar f ~where:"$" name typ) in
  arg "file" charConstPtrType;
  arg "line" uintType;
  arg "address" voidPtrType;
  arg "size" uintType;
  arg "data" voidPtrType;
  f.svar
    

let addPrototype file =
  file.globals <- GVarDecl (logWrite, logWrite.vdecl) :: file.globals
