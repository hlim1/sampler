open Cil
  

let logIsImminent =
  makeGlobalVar "logIsImminent" (TFun (intType,
				       Some [ "within", uintType, [] ],
				       false,
				       []))


let choose func location weight original instrumented =
  let imminent = makeTempVar func ~name:"imminent" intType in
  let lval = (Var imminent, NoOffset) in
  let call = Call (Some lval, Lval (var logIsImminent), [kinteger IUInt weight], location) in
  let branch = If (Lval lval, instrumented, original, location) in
  mkBlock [mkStmtOneInstr call; mkStmt branch]
    
    
let addPrototype file =
  file.globals <- GVarDecl (logIsImminent, logIsImminent.vdecl) :: file.globals
