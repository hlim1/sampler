open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    let predicate = one in
    let original = func.sbody in
    let clone = Duplicate.duplicateBody func in
    let instrumented = Instrument.instrumentBlock clone in
    let choice = mkStmt (If (predicate, original, instrumented, func.svar.vdecl)) in
    func.sbody <- mkBlock [choice];
    SkipChildren
end


let phase _ =
  ("Transform",
   fun file ->
     Instrument.addPrototype file;
     visitCilFileSameGlobals new visitor file)
