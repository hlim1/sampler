open Cil


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  if replacement != original then
    failwith "instrumentation visitor unexpectedly replaced block"


class virtual visitor = object(self)
  inherit FunctionBodyVisitor.visitor

  method virtual weigh : stmt -> int
  method virtual insertSkips : cilVisitor
  method virtual insertLogs : cilVisitor

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    let afterCalls = AfterCalls.split func in
    ignore (computeCFGInfo func false);
    
    let forwardJumps, backwardJumps = ClassifyJumps.visit func in
    
    let entry = FunctionEntry.find func in
    let headers = entry :: backwardJumps @ afterCalls in
    
    begin
      match WeighPaths.weigh self#weigh headers with
      | None -> ()
      | Some weights ->    
	  let original, instrumented, clones = Duplicate.duplicateBody func in
	  
	  ForwardJumps.patch clones forwardJumps;
	  BackwardJumps.patch clones weights backwardJumps;
	  AfterCalls.patch clones weights afterCalls;
	  
	  FunctionEntry.patch func weights instrumented;
	  visitSameBlock self#insertSkips original;
	  visitSameBlock self#insertLogs instrumented
    end;

    SkipChildren
end
