open Cil


class virtual visitor file = object(self)
  inherit FunctionBodyVisitor.visitor

  val logger = Logger.call file
  val countdownToken = Countdown.find file

  method virtual collectOutputs : fundec -> stmtkind -> Sites.outputs
  method virtual placeInstrumentation : stmt -> stmt list -> stmt list

  method instrumentFunction func =
    prepareCFG func;
    RemoveLoops.visit func;
    IsolateInstructions.visit func;
    let afterCalls = Calls.prepatch func in
    let cfg = computeCFGInfo func false in
    let sites = Sites.collect (self#collectOutputs func) cfg in

    let extraGlobals = ref [] in

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
	FunctionEntry.patch func weights countdown instrumented;
	Calls.postpatch func countdown;
	
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
	  let instrumentation = logger location outputs extraGlobals in
	  let conditional = countdown#log location instrumentation in
	  combine clone conditional
	in
	
	sites#iter instrument
      end;
    !extraGlobals

  method vglob = function
    | GFun (func, _) as global
      when not (hasAttribute "no_instrument_function" func.svar.vattr) ->
	begin
	  match self#instrumentFunction func with
	  | [] -> SkipChildren
	  | extras ->
	      ChangeTo (extras @ [global])
	end
    | _ ->
	SkipChildren
end
