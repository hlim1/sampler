open Cil


class virtual visitor file =
  object (self)
    inherit SkipVisitor.visitor

    val countdownToken = Countdown.find file

    method private virtual collector : fundec -> Collector.visitor

    method private prepatchCalls = Calls.prepatch

    method private transform func =
      prepareCFG func;
      RemoveLoops.visit func;
      IsolateInstructions.visit func;
      let placeholders = self#prepatchCalls func in
      let collector = self#collector func in
      ignore (visitCilFunction (collector :> cilVisitor) func);

      begin
	match collector#sites with
	| [] -> ()
	| sitesList ->
	    ignore (computeCFGInfo func false);
	    let sites = new StmtSet.container in
	    List.iter sites#add sitesList;

	    let forwardJumps, backwardJumps = ClassifyJumps.visit func in
	    let entry = FunctionEntry.find func in
	    let afterCalls = List.map (fun (_, _, _, landing) -> landing) placeholders in
	    let headers = entry :: backwardJumps @ afterCalls in
	    let weights = WeighPaths.weigh sites headers in
	    let countdown = new Countdown.countdown countdownToken func in
	    let original, instrumented, clones = Duplicate.duplicateBody func in
	    
	    ForwardJumps.patch clones forwardJumps;
	    BackwardJumps.patch clones weights countdown backwardJumps;
	    Calls.patch clones weights countdown placeholders;
	    FunctionEntry.patch func weights countdown instrumented;
	    Returns.patch func countdown;
	    
	    let instrument original =
	      let location = get_stmtLoc original.skind in
	      let decrement = countdown#decrement location in
	      let clone = ClonesMap.findCloneOf clones original in
	      original.skind <- decrement;
	      clone.skind <- countdown#decrementAndCheckZero clone.skind
	    in
	    
	    sites#iter instrument;

	    (* DeadCode.visit func *)
      end;

      collector#globals

    method vglob = function
      | GFun (func, _) as global
	when ShouldTransform.shouldTransform func ->
	  begin
	    match self#transform func with
	    | [] -> SkipChildren
	    | globals -> ChangeTo (globals @ [global])
	  end
      | _ ->
	  SkipChildren
  end
