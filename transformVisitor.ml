open Cil


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  assert (replacement == original)


class virtual ['siteInfo] visitor file = object(self)
  inherit FunctionBodyVisitor.visitor

  val globalCountdown = Countdown.findGlobal file
      
  method virtual findSites : block -> 'siteInfo
  method virtual insertSkips : 'siteInfo -> Countdown.countdown -> cilVisitor
  method virtual insertLogs : ClonesMap.clonesMap -> 'siteInfo -> unit

  method vfunc func =
    prepareCFG func;
    RemoveLoops.visit func;
    IsolateInstructions.visit func;
    let afterCalls = Calls.prepatch func in
    ignore (computeCFGInfo func false);
    
    let forwardJumps, backwardJumps = ClassifyJumps.visit func in
    
    let entry = FunctionEntry.find func in
    let headers = entry :: backwardJumps @ afterCalls in
    let sites = self#findSites func.sbody in
    
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
	  visitSameBlock (self#insertSkips sites countdown) original;

	  self#insertLogs clones sites;
	  Calls.postpatch func countdown;
    end;

    SkipChildren
end
