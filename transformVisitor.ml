open Cil


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  assert (replacement == original)


class virtual visitor file =
  let skipLog = SkipLog.find file in
  let countdown = Countdown.find file in
  
  object(self)
    inherit FunctionBodyVisitor.visitor

    method virtual weigh : stmt -> int
    method virtual insertSkips : SkipLog.closure -> cilVisitor
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
	    BackwardJumps.patch clones weights countdown backwardJumps;
	    AfterCalls.patch clones weights countdown afterCalls;
	    
	    FunctionEntry.patch func weights countdown instrumented;
	    visitSameBlock (self#insertSkips skipLog) original;
	    visitSameBlock self#insertLogs instrumented
      end;

      SkipChildren
  end
