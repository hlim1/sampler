open Calls
open Cil
open ClassifyJumps
open FuncInfo


let removeDeadCode = ref true

let _ =
  Options.registerBoolean
    removeDeadCode
    ~flag:"remove-dead-code"
    ~desc:"remove dead code"
    ~ident:"RemoveDeadCode"


(**********************************************************************)


let visit isWeightlessCallee countdownToken func info =
  if info.sites != [] then
    begin
      ignore (computeCFGInfo func false);
      let entry = FunctionEntry.find func in
      let jumps = ClassifyJumps.visit func in
      let weightyCalls = List.filter (fun call -> not (isWeightlessCallee call.callee)) info.calls in
      let afterCalls = List.map (fun info -> info.landing) weightyCalls in
      let headers = entry :: jumps.backward @ afterCalls in
      ignore (computeCFGInfo func false);
      let weights = WeighPaths.weigh info.sites headers in
      
      let countdown = countdownToken func in
      let original, instrumented, clones = Duplicate.duplicateBody func in
      
      ForwardJumps.patch clones jumps.forward;
      BackwardJumps.patch clones weights countdown jumps.backward;
      CallsPatch.patch clones weights countdown weightyCalls;
      FunctionEntry.patch func weights countdown instrumented;
      Returns.patch func countdown;
      List.iter (Sites.patch clones countdown) info.sites;

      if !Stats.showStats then
	begin
	  let siteCount = List.length info.sites in

	  let headerTotal, headerCount =
	    weights#fold
	      (fun _ weight (total, count) ->
		if weight == 0 then
		  (total, count)
		else
		  (total + weight, count + 1))
	      (0, 0)
	  in
	  Printf.eprintf "stats: transform: %s has sites: %d sites, %d headers, %d total header weights\n"
	    func.svar.vname siteCount headerCount headerTotal
	end;

      if !removeDeadCode then
	DeadCode.visit func;

      FilterLabels.visit func;
      MergeBlocks.visit func;
      FilterLabels.visit func
    end
