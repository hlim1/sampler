open Calls
open Cil
open ClassifyJumps
open FuncInfo


let removeDeadCode = 
  Options.registerBoolean
    ~flag:"remove-dead-code"
    ~desc:"remove dead code"
    ~ident:"RemoveDeadCode"
    ~default:true


(**********************************************************************)


class showCFG =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt statement =
      ignore (Pretty.eprintf "%a@!    @[%a@]@!"
		Utils.d_stmt statement
		Utils.d_stmts statement.succs);
      DoChildren
  end


let visit isWeightyCallee countdown (func, sites) =
  assert (sites != []);

  IsolateInstructions.visit func;
  let entry = mkStmt (Block func.sbody) in
  func.sbody <- mkBlock [entry];

  let countdown = countdown func in
  let afterCalls = WeightyCalls.prepatch isWeightyCallee func countdown in
  Cfg.build func;

  let jumps = ClassifyJumps.visit func in
  let callJumps = WeightyCalls.jumpify afterCalls in
  let backJumps = jumps.backward @ callJumps in
  let headers = entry :: backJumps in
  let weights = WeighPaths.weigh sites headers in
  
  let original, instrumented, clones = Duplicate.duplicateBody func in
  
  ForwardJumps.patch clones jumps.forward;
  BackwardJumps.patch clones weights countdown backJumps;
  FunctionEntry.patch func weights countdown instrumented;
  Returns.patch func countdown;
  List.iter (Sites.patch clones countdown) sites;

  if !Statistics.showStats then
    begin
      let siteCount = List.length sites in

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
