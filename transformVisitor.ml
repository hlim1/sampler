open Cil


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  assert (replacement == original)


class virtual visitor file = object(self)
  inherit FunctionBodyVisitor.visitor

  val globalCountdown = Countdown.findGlobal file

  method virtual findSites : fundec -> Sites.visitor
  method virtual placeInstrumentation : stmt -> stmt -> stmt list

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    IsolateInstructions.visit func;
    let afterCalls = Calls.prepatch func in
    ignore (computeCFGInfo func false);
    
    let forwardJumps, backwardJumps = ClassifyJumps.visit func in
    
    let entry = FunctionEntry.find func in
    let headers = entry :: backwardJumps @ afterCalls in

    let sitesVisitor = self#findSites func in
    ignore (visitCilFunction (sitesVisitor :> cilVisitor) func);
    let sites = sitesVisitor#result in
    
    begin
      match WeighPaths.weigh sites headers with
      | None -> ()
      | Some weights ->    
	  let countdown = new Countdown.countdown globalCountdown func in
	  let original, instrumented, clones = Duplicate.duplicateBody func in
	  
	  ForwardJumps.patch clones forwardJumps;
	  BackwardJumps.patch clones weights countdown backwardJumps;
	  Calls.patch clones weights countdown afterCalls;
	  FunctionEntry.patch func weights countdown instrumented;
	  
	  let combine code instrumentation =
	    let codeStmt = mkStmt code.skind in
	    let instStmt = mkStmtOneInstr instrumentation in
	    let combined = self#placeInstrumentation codeStmt instStmt in
	    code.skind <- Block (mkBlock combined)
	  in
	  
	  let instrument original instrumentation =
	    let location = get_stmtLoc original.skind in
	    let skip = countdown#decrement location in
	    combine original skip;
	    
	    let clone = ClonesMap.findCloneOf clones original in
	    combine clone instrumentation
	  in
	  
	  sites#iter instrument;
	  
	  Calls.postpatch func countdown;
    end;

    SkipChildren
end
