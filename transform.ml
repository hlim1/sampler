open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    ignore (computeCFGInfo func false);	(* for sid's only *)

    let predicate = zero in
    let original = func.sbody in
    let instrumented = Duplicate.duplicateBody func in

    InstrumentWrites.visit func instrumented;
    
    let choice = mkStmt (If (predicate, original, instrumented, func.svar.vdecl)) in
    func.sbody <- mkBlock [choice];
    SkipChildren
end


let phase _ =
  ("Transform",
   fun file ->
     Instrument.addPrototype file;
     visitCilFileSameGlobals new visitor file)
