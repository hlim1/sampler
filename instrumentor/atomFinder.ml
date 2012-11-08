open Cil
open Helpers
open Interesting


class visitor file =
  let gsampling = var (FindGlobal.find "cbi_atomsSampling" file) in
  let lock_func   = Lval (var (FindFunction.find "cbi_atoms_lock"   file)) in
  let unlock_func = Lval (var (FindFunction.find "cbi_atoms_unlock" file)) in
  let sampling_on_func  = Lval (var (FindFunction.find "cbi_atoms_sampling_on" file)) in
  let sampling_off_func = Lval (var (FindFunction.find "cbi_atoms_sampling_off" file)) in
  let cbi_thread_self = FindFunction.find "cbi_thread_self" file in
  let tid_type, _, _, _ = splitFunctionTypeVI cbi_thread_self in

  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method! vstmt stmt =

	let get_init_ctid_instr () =
	  let result = var (makeTempVar ~name:"cbi_thread_id" func tid_type) in
	  let tid_func = Lval (var cbi_thread_self) in
	  let expr = Lval result in
	  let call = Call (Some result, tid_func, [], !currentLoc) in
	  call, expr
	in

	match stmt.skind with
	| Instr [Set (left, _, _) as instr]
	  when self#includedStatement stmt ->
	    begin
	      match SharedAccesses.isolated instr with
	      | Some lval when ((not (is_bitfield lval)) && (isDiscreteType (typeOfLval lval))) ->
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
		    let thread_id_call, thread_id_expr = get_init_ctid_instr () in
		    let isDifferent = var (findOrCreate_local_type func "cbi_isDifferent" intType) in
		    let isStale =  var (findOrCreate_local_type func "cbi_isStale" intType) in
		    let isFound =  var (findOrCreate_local_type func "cbi_isFound" intType) in
		    let isCur = UnOp (LNot, Lval isStale, intType) in
		    let test_set_func = Lval (var (FindFunction.find "cbi_dict_test_and_insert" file)) in
		    let test_set_args = [Cil.mkCast (mkAddrOrStartOf lval) Cil.uintType;
					 thread_id_expr;
					 mkAddrOf isDifferent;
					 mkAddrOf isStale]
		    in
		    let test_set_call = Call (Some isFound, test_set_func, test_set_args, !currentLoc) in
		    let different_index = BinOp(LAnd, Lval isFound, Lval isDifferent, intType) in

		    (**** ***)
		    (* this is only needed because the number of bumps should equal the number of sampled blocks *)
		    let dummy_instr =
		      let tmp = var (findOrCreate_local func "cbi_dummy") in
		      Set (tmp, zero, !currentLoc)
		    in
		    let dummy_sample = tuples#addSiteInstrs (siteInfo ()) [dummy_instr] in

		    (* let bump_stmt = make_stmt (bump_instrs) in *)

		    [mkStmtOneInstr (Call (None, lock_func, [], !currentLoc));
		     mkStmtOneInstr thread_id_call;
		     mkStmtOneInstr test_set_call;
		     mkStmt (If (isCur,
				 mkBlock [mkStmtOneInstr (fst (tuples#addExpr different_index))],
				 mkBlock [mkEmptyStmt()],
				 !currentLoc));
                     mkStmtOneInstr (fst (tuples#addExpr different_index));
		     mkStmtOneInstr instr;
		     mkStmtOneInstr (Call (None, sampling_off_func, [], !currentLoc));
		     mkStmtOneInstr (Call (None, unlock_func, [], !currentLoc));
		     dummy_sample]
		  in

		  let off_blk =
		    let sampled_stmt =
		      let set_instrs = [Call (None, sampling_on_func, [], !currentLoc)] in
		      tuples#addSiteInstrs (siteInfo ()) set_instrs
		    in
		    [mkStmtOneInstr instr; sampled_stmt]
		  in

		  stmt.skind <- If (Lval gsampling,
				    mkBlock on_blk,
				    mkBlock off_blk,
				    !currentLoc)

	      | Some _
	      | None ->
		  ()
	    end;
	    SkipChildren

(*	| Return _
	  when self#includedStatement stmt  ->
	    let reset_stmt = Call (None, sampling_off_func, [], !currentLoc) in
	    self#queueInstr [reset_stmt];
	    SkipChildren
*)
	| _ ->
	    DoChildren

    end
