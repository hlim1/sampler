open Cil
open Printf


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  if replacement != original then
    failwith "instrumentation visitor unexpectedly replaced block"


let transform scale insertSkips instrument func =
  prepareCFG func;
  RemoveLoops.visit func;
  let afterCalls = AfterCalls.split func in
  ignore (computeCFGInfo func false);
  
  let forwardJumps, backwardJumps = ClassifyJumps.visit func in
  
  let entry = FunctionEntry.find func in
  let headers = entry :: backwardJumps @ afterCalls in
  
  begin
    match WeighPaths.weigh scale headers with
    | None -> ()
    | Some weights ->    
	let original, instrumented, clones = Duplicate.duplicateBody func in
	
	ForwardJumps.patch clones forwardJumps;
	BackwardJumps.patch clones weights backwardJumps;
	AfterCalls.patch clones weights afterCalls;
	
	visitSameBlock insertSkips original;
	FunctionEntry.patch func weights instrumented;
	visitSameBlock instrument instrumented
  end
