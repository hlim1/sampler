open Cil
open Weight


let balanceLabel = Labels.build "balance"


type t = (WeighPaths.weightsMap -> unit) list


let pushBalancer block =
  let balancer = mkEmptyStmt () in
  block.bstmts <- balancer :: block.bstmts;
  balancer


let prepatch func =

  let makeDummies weights stmt =
    let lookup node = (weights#find node).threshold in
    let threshold = lookup stmt in
    fun succ ->
      let succThreshold = lookup succ in
      let dummies = ref [] in
      for difference = succThreshold + 1 to threshold do
	let dummy = mkEmptyStmt () in
	Sites.registry#add func (Site.build dummy);
	dummies := dummy :: !dummies
      done;
      Block (mkBlock !dummies)
  in

  if !BalancePaths.balancePaths then
    let folder splits = function
      | { succs = [] }
      | { succs = [_] } ->
	  splits

      | { skind = If (_, thenBlock, elseBlock, _) } as stmt ->
	  (* placeholders whose weights we can ask for later *)
	  let thenBalancer = pushBalancer thenBlock in
	  let elseBalancer = pushBalancer elseBlock in
	  begin
	    fun weights ->
	      let makeDummies = makeDummies weights stmt in
	      let balanceBranch succ =
		let dummies = makeDummies succ in
		succ.skind <- dummies
	      in
	      balanceBranch thenBalancer;
	      balanceBranch elseBalancer
	  end
	  :: splits

      | { skind = Switch (expr, block, cases, location) } as stmt ->
	  let cases =
	    if Cfg.hasDefault cases then
	      cases
	    else
	      let default = mkEmptyStmt () in
	      default.labels <- [Default location];
	      block.bstmts <- block.bstmts @ [default];
	      let cases = cases @ [default] in
	      assert (Cfg.hasDefault cases);
	      stmt.skind <- Switch (expr, block, cases, location);
	      cases
	  in
	  begin
	    fun weights ->
	      let newCases =
		let makeDummies = makeDummies weights stmt in
		let balanceCase case =
		  let dummies = mkStmt (makeDummies case) in
		  let gotoLabels, switchLabels =
		    let folder (gotos, switches) label =
		      match label with
		      | Label _ ->
			  label :: gotos, switches
		      | Case _
		      | Default _ ->
			  gotos, label :: switches
		    in
		    List.fold_left folder ([], []) case.labels
		  in
		  assert (switchLabels <> []);
		  let skipTo = mkEmptyStmt () in
		  case.skind <- Block (mkBlock [dummies; skipTo; mkStmt case.skind]);
		  dummies.labels <- switchLabels;
		  skipTo.labels <- gotoLabels;
		  case.labels <- [];
		  let patchPred pred =
		    match pred.skind with
		    | Goto (target, location) ->
			assert (!target == case);
			pred.skind <- Labels.buildGoto balanceLabel skipTo location
		    | other ->
			if pred != stmt then
			  let location = get_stmtLoc other in
			  pred.skind <- Block (mkBlock [mkStmt pred.skind;
							mkStmt (Labels.buildGoto balanceLabel skipTo location)])
		  in
		  List.iter patchPred case.preds;
		  dummies
		in
		List.map balanceCase cases
	      in
	      stmt.skind <- Switch (expr, block, newCases, location)
	  end
	  :: splits

      | stmt ->
	  ignore (bug "%s: unexpected kind of multi-successor statement" (Utils.stmt_describe stmt.skind));
	  failwith "internal error"
    in
    List.fold_left folder [] func.sallstmts
  else
    []


let patch splits weights =
  List.iter (fun split -> split weights) splits
