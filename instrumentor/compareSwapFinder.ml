open Cil
open Helpers
open Interesting


class visitor file =
  let comparesampling = var (FindGlobal.find "cbi_compareSwapSampling" file) in
  let sampling_on_func  = Lval (var (FindFunction.find "cbi_compareSwap_sampling_on" file)) in
  let sampling_off_func = Lval (var (FindFunction.find "cbi_compareSwap_sampling_off" file)) in

  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method! vstmt stmt =

	match stmt.skind with
	| Instr [Set (left, _, _) as instr]
	  when self#includedStatement stmt ->
	    begin
	      match SharedAccesses.isolated instr with
	      | Some lval when not (is_bitfield lval) ->
                begin
		  match isDiscreteType (typeOfLval lval) with
		  | false -> ()
		  | true -> (* only instrument scalar variables *)
			let siteInfo =
			  let accessType =
			    if left == lval then
			      AccessSiteInfo.Write
			    else
			      AccessSiteInfo.Read
			  in
			  fun () ->
			    new AccessSiteInfo.c func !currentLoc lval accessType
			in

			let on_blk =
			  let isDifferent = var (findOrCreate_local_type func "cbi_isDifferent" intType) in
			  let isStale =  var (findOrCreate_local_type func "cbi_isStale" intType) in
			  let isFound =  var (findOrCreate_local_type func "cbi_isFound" intType) in
			  let isCur = UnOp (LNot, Lval isStale, intType) in
			  let test_set_func = Lval (var (FindFunction.find "cbi_dict_test_and_insert" file)) in
			  let test_set_args = [Cil.mkCast ~e:(mkAddrOrStartOf lval) ~newt:Cil.uintType;
					       Cil.mkCast ~e:(Lval lval) ~newt:Cil.uintType;
					       mkAddrOf isDifferent;
					       mkAddrOf isStale]
			  in
			  let test_set_call = Call (Some isFound, test_set_func, test_set_args, !currentLoc) in
			  let different_index = BinOp(LAnd, Lval isFound, Lval isDifferent, intType) in


			  let insert_func = Lval (var (FindFunction.find "cbi_dict_insert" file)) in
			  let insert_args = [Cil.mkCast ~e:(mkAddrOrStartOf lval) ~newt:Cil.uintType;
					     Cil.mkCast ~e:(Lval lval) ~newt:Cil.uintType]
			  in
			  let insert_call = 
			    if left == lval then
                              mkStmtOneInstr (Call (None, insert_func, insert_args, !currentLoc))
                            else
                              mkEmptyStmt()
                          in

			  (**** ***)
			  (* this is only needed because the number of bumps should equal the number of sampled blocks *)
			  let dummy_instr =
			    let tmp = var (findOrCreate_local func "cbi_dummy") in
			    Set (tmp, zero, !currentLoc)
			  in
			  let dummy_sample = tuples#addSiteInstrs (siteInfo ()) [dummy_instr] in

			  (* let bump_stmt = make_stmt (bump_instrs) in *)

			  [(*mkStmtOneInstr (Call (None, lock_func, [], !currentLoc));
			   mkStmtOneInstr thread_id_call; *)
			   mkStmtOneInstr test_set_call;
			   mkStmt (If (isCur,
				   mkBlock [mkStmtOneInstr (fst (tuples#addExpr different_index))],
				   mkBlock [mkEmptyStmt()],
				   !currentLoc));
                           mkStmtOneInstr (fst (tuples#addExpr different_index));
			   mkStmtOneInstr instr;
                           insert_call;
			   mkStmtOneInstr (Call (None, sampling_off_func, [], !currentLoc));
			   (*mkStmtOneInstr (Call (None, unlock_func, [], !currentLoc));*)
			   dummy_sample]
			in

			let off_blk =
			  let sampled_stmt =
			    let set_instrs = [Call (None, sampling_on_func, [], !currentLoc)] in
			    tuples#addSiteInstrs (siteInfo ()) set_instrs
			  in
			  [mkStmtOneInstr instr; sampled_stmt]
			in

			stmt.skind <- If (Lval comparesampling,
					  mkBlock on_blk,
					  mkBlock off_blk,
					  !currentLoc)
                    end

	      | Some _
	      | None ->
		  ()
	    end;
	    SkipChildren

	| Return _
	  when self#includedStatement stmt  ->
	    let reset_stmt = Call (None, sampling_off_func, [], !currentLoc) in
	    self#queueInstr [reset_stmt];
	    SkipChildren

	| _ ->
	    DoChildren

    end
