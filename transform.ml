open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    ignore (computeCFGInfo func false);

    let forwards, backwards = ClassifyJumps.visit func in
    let headers = FunctionEntry.find func :: backwards in
    let weights = WeighPaths.weigh headers in
    let instrumented, clones = Duplicate.duplicateBody func in

    ForwardJumps.patch clones forwards;
    BackwardJumps.patch clones weights func backwards;
    FunctionEntry.patch func weights instrumented;

    InstrumentWrites.visit func instrumented;
    
    SkipChildren
end


let phase _ =
  ("Transform",
   fun file ->
     LogIsImminent.addPrototype file;
     LogWrite.addPrototype file;
     visitCilFileSameGlobals new visitor file)
