open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    ignore (computeCFGInfo func false);
    
    let forwards, backwards = ClassifyJumps.visit func in
    let weights = WeighPaths.weigh backwards in
    let instrumented, clones = Duplicate.duplicateBody func in

    ForwardJumps.patch clones forwards;
    BackwardJumps.patch clones weights backwards;
    InstrumentWrites.visit func instrumented;
    
    let predicate = zero in
    let original = func.sbody in
    let choice = mkStmt (If (predicate, original, instrumented, func.svar.vdecl)) in
    func.sbody <- mkBlock [choice];
    SkipChildren
end


let phase _ =
  ("Transform",
   fun file ->
     LogWrite.addPrototype file;
     visitCilFileSameGlobals new visitor file)
