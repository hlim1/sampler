open Cil
open Printf


class visitor = object
  inherit FunctionBodyVisitor.visitor

  method vfunc func =
    prepareCFG func;
    
    let predicate = zero in
    let original = func.sbody in
    let instrumented = Duplicate.duplicateBody func in

    let visitors = [
      "RemoveLoops", (fun _ -> new RemoveLoops.visitor);
      "SimplifyReturns", new SimplifyReturns.visitor;
      "SimplifyLefts", new SimplifyLefts.visitor;
      "SimplifyRights", new SimplifyRights.visitor;
      "CheckSimplicity", (fun _ -> new CheckSimplicity.visitor);
      "Instrument", (fun _ -> new Instrument.visitor)
    ] in
    
    let visit (title, visitor) =
      eprintf "  subphase %s begins\n" title;
      let replacement = visitCilBlock (visitor func) instrumented in
      if replacement != instrumented then
	failwith "unexpectedly got changed block";
      eprintf "  subphase %s ends\n" title
    in

    List.iter visit visitors;

    let choice = mkStmt (If (predicate, original, instrumented, func.svar.vdecl)) in
    func.sbody <- mkBlock [choice];
    SkipChildren
end


let phase _ =
  ("Transform",
   fun file ->
     Instrument.addPrototype file;
     visitCilFileSameGlobals new visitor file)
