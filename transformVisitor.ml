open Cil


let visitSameBlock visitor original =
  let replacement = visitCilBlock visitor original in
  assert (replacement == original)


class virtual visitor file = object(self)
  inherit FunctionBodyVisitor.visitor

  val logger = Logger.call file
  val countdownToken = Countdown.find file

  method virtual collectOutputs : fundec -> stmtkind -> Sites.outputs
  method virtual placeInstrumentation : stmt -> stmt list -> stmt list

  method vfunc func =
    if not (hasAttribute "no_instrument_function" func.svar.vattr) then
      begin
	prepareCFG func;
	RemoveLoops.visit func;
	IsolateInstructions.visit func;
	let afterCalls = Calls.prepatch func in
	let cfg = computeCFGInfo func false in
	let sites = Sites.collect (self#collectOutputs func) cfg in

	if not sites#isEmpty then
	  begin
	    let forwardJumps, backwardJumps = ClassifyJumps.visit func in
	    let entry = FunctionEntry.find func in
	    let headers = entry :: backwardJumps @ afterCalls in
	    let weights = WeighPaths.weigh sites headers in
	    let countdown = new Countdown.countdown countdownToken func in
	    let original, instrumented, clones = Duplicate.duplicateBody func in
	    
	    ForwardJumps.patch clones forwardJumps;
	    BackwardJumps.patch clones weights countdown backwardJumps;
	    Calls.patch clones weights countdown afterCalls;
	    Calls.postpatch func countdown;
	    FunctionEntry.patch func weights countdown instrumented;
	    
	    let combine code instrumentation =
	      let codeStmt = mkStmt code.skind in
	      let combined = self#placeInstrumentation codeStmt instrumentation in
	      code.skind <- Block (mkBlock combined)
	    in
	    
	    let instrument original outputs =
	      let location = get_stmtLoc original.skind in
	      let skip = countdown#decrement location in
	      combine original [mkStmtOneInstr skip];
	      
	      let clone = ClonesMap.findCloneOf clones original in
	      let instrumentation = logger location outputs in
	      let conditional = countdown#log location instrumentation in
	      combine clone conditional
	    in
	    
	    sites#iter instrument
	  end
      end;

    SkipChildren
end
