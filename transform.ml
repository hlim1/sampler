open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    let calls = SplitAfterCalls.visit func in
    ignore (computeCFGInfo func false);

    let forwards, backwards = ClassifyJumps.visit func in
    let headers = FunctionEntry.find func :: calls @ backwards in
    let weights = WeighPaths.weigh headers in
    let instrumented, clones = Duplicate.duplicateBody func in

    ForwardJumps.patch clones forwards;
    BackwardJumps.patch clones weights func backwards;
    SkipWrites.visit func;
    FunctionEntry.patch func weights instrumented;
    InstrumentWrites.visit func instrumented;
    
    SkipChildren
end


let phase =
  "Transform",
  visitCilFileSameGlobals new visitor
