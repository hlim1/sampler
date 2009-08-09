open Cil
open Helpers

let postpatch replacement statement =
  statement.skind <- replacement;
  statement


class visitor file =
  fun (tuples : Counters.manager) func  ->
    object (self)
      inherit SiteFinder.visitor

      method vstmt stmt =

	(* given a list of instrs, returns a block*)
	  let make_block instructions = 
	    let slist = List.map (fun i -> mkStmtOneInstr i ) instructions in
	    (mkBlock slist) in

(* 	  let make_stmt instructions = *)
(* 	    mkStmt (Block(make_block instructions)) *)
(* 	  in *)

	  let skip_lval lv =
	    if ((is_bitfield lv) || (is_register lv))
	    then true
	    else ( let lh,_ = lv in
	      match lh with Var(vi) ->  (not(vi.vglob)) (* Don't skip globals *)
	      |_ -> false ) 
	  in
	      

	  (* given an expression, returns all non-bitfield lvals *)
	  (* ommitting bitfields because we can't take address of bitfields*)
	  let rec get_lvals expr =
	    match expr with 
	      Lval(lv) -> if (skip_lval lv) then [] else [lv]
	    | UnOp(_, e, _) -> (get_lvals e)
	    | BinOp(_, e1 ,e2, _) -> (get_lvals e1)@(get_lvals e2)
	    | AlignOfE(e) -> (get_lvals e)
	    | CastE(_,e) -> (get_lvals e)
	    | AddrOf(lv) ->  if (skip_lval lv) then [] else [lv]
	    | StartOf(lv) ->  if (skip_lval lv) then [] else [lv] 
	    | _ -> [] in

	  let rec list_get_lvals exprlist lvals = 
	    match exprlist with []  -> lvals
	    | expr::tail -> let lvs = get_lvals expr in
	      (list_get_lvals tail lvals@lvs) in

(* 	  let is_varargs_call lv = *)
(* 	    let (lh,_) = lv in *)
(* 	    match lh  *)
(* 	    with Var(vi) -> ( match vi.vtype with TFun(_,_,true,_) -> true | _->false ) *)
(* 	    |_-> false in *)

	  let get_gsample_lval () =
	    var (findOrCreate_global file ((get_prefix_file file)^"_gsample") ) 
	  in

	  let get_iset_lval () =
	    var (findOrCreate_local func ("cbi_iSet"))
	  in


	  let get_ctid_lval () =
	    var (findOrCreate_local_type func "cbi_tid_temp" ulongType) 
	  in

	  let get_init_ctid_instr location =
	    let cur_tid = get_ctid_lval() in
	    let tid_func = Lval (var (FindFunction.find "cbi_thread_self" file)) in
	    (Call (Some(cur_tid), tid_func, [], location))
	  in


	  let rec __get_selectors location lvals stmts cur_selector stale_selector isAnyCur isAnyStale i =
	    match lvals with [] -> (stmts, cur_selector, stale_selector, isAnyCur, isAnyStale) 
	    | lv::tail -> 
		let cur_tid = get_ctid_lval() in 
		let isDifferent = var (findOrCreate_local_type func ("cbi_isDifferent_"^( string_of_int i) ) ulongType) in
		let isStale =  var (findOrCreate_local_type func ("cbi_isStale_"^( string_of_int i) ) ulongType) in
		let isFound =  var (findOrCreate_local_type func ("cbi_isFound_"^( string_of_int i) ) ulongType) in
		let test_set_func = Lval (var (FindFunction.find "cbi_dict_test_and_insert" file)) in
		let call = mkStmtOneInstr (Call( Some( isFound), test_set_func, 
				 [(Cil.mkCast (mkAddrOrStartOf lv) Cil.uintType); (Lval cur_tid); (mkAddrOrStartOf isDifferent); (mkAddrOrStartOf isStale) ], location)) in
		let cur_selector =  BinOp(LOr,
					  cur_selector,
					  BinOp(LAnd,
						Lval isFound,
						BinOp(LAnd,
						      Lval isDifferent,
						      UnOp(LNot, (Lval isStale), intType),
						      intType), intType), intType)in
		let stale_selector = BinOp(LOr,
					   stale_selector,
					   BinOp(LAnd,
						 Lval isFound,
						 BinOp(LAnd,
						       Lval isDifferent, Lval isStale, intType),
						 intType), intType) in
		let isAnyCur = BinOp(LOr, 
				     UnOp(LNot, (Lval isStale), intType),
				     isAnyCur, intType) in
		let isAnyStale = BinOp(LOr, Lval isStale, isAnyStale, intType) in
		__get_selectors location tail (stmts@[call]) cur_selector stale_selector isAnyCur isAnyStale (i+1) 
	  in

	  let get_selectors location lvals =
	    let init_ctid_instr = mkStmtOneInstr(get_init_ctid_instr location) in 
	    let stmts, cur_selector, stale_selector, isAnyCur, isAnyStale = (__get_selectors location lvals [mkEmptyStmt()] zero zero zero zero 0) in
	    (mkStmt (Block(mkBlock (init_ctid_instr::stmts))), cur_selector, stale_selector, isAnyCur, isAnyStale)
	  in


	  let get_set_sampling_instrs location =
	    let iset = get_iset_lval() in
	    let gsample = get_gsample_lval() in
	    [Set(gsample, one, location); Set(iset, one, location)] 
	  in

	  let get_dummy_instr location =
	    let tmp = var (findOrCreate_local func ("cbi_dummy")) in
	    Set(tmp, zero, location)
	  in
						      

	  let get_sampled_set_stmt location orig_instr = 
	      let set_instrs = (get_set_sampling_instrs location) in
	      let siteInfo = new InstrSiteInfo.c func location orig_instr in
	      (tuples#addSiteInstrs siteInfo (set_instrs)) 
	  in

	  let get_reset_sampling_stmt location =
	    let clear_func = Lval (var (FindFunction.find "cbi_dict_clear" file)) in
	    let clear_dict = Call (None, clear_func,[], location) in
	    let iset = get_iset_lval() in
	    let reset_gsample = Set(get_gsample_lval() , zero, location) in
	    let reset_iset = Set(iset, zero, location) in
	    let reset_blk = make_block [reset_gsample; reset_iset; clear_dict ] in
	    let empty_blk = mkBlock[ mkEmptyStmt() ] in
	    let reset_cond = (BinOp(Eq, (Lval iset), one, intType)) in
	    mkStmt ( If(reset_cond,reset_blk, empty_blk, location )) 
	    in

	  let get_off_blk location orig_instr execute_stmt =
	      let sampled_stmt = get_sampled_set_stmt location orig_instr in 
	      let off_blk = mkBlock[ execute_stmt; sampled_stmt ] in
	      off_blk
	  in

	  let get_on_blk location lvals orig_instr execute_stmt =
	    let selector_stmt, cur_selector, stale_selector, isAnyCur, _ = get_selectors location lvals in
(* 	      let bump_instrs,_ = tuples#addExpr2 cur_selector stale_selector in *)
	      let bump_instr1,_ = tuples#addExpr cur_selector in
	      let bump_instr2,_ = tuples#addExpr stale_selector in
	      let bump_stale = mkBlock[ (mkStmtOneInstr bump_instr2)] in

	      let bump_cur = mkBlock[mkStmtOneInstr (bump_instr1)] in
	      let bump_cur = mkStmt( If(isAnyCur, bump_cur, bump_stale, location)) in

(* 	      let bump_stale = mkStmt( If(isAnyStale, bump_stale, mkBlock[mkEmptyStmt()], location)) in *)

	      (**** ***)
	      (* this is only needed because the number of bumps should equal the number of sampled blocks *)
	      let siteInfo = new InstrSiteInfo.c func location orig_instr in
	      let dummy_sample = (tuples#addSiteInstrs siteInfo [get_dummy_instr location] ) in

(* 	      let bump_stmt = make_stmt (bump_instrs) in *)

	      let reset_stmt = get_reset_sampling_stmt location in

	      let lock_func = Lval (var (FindFunction.find "cbi_atoms_lock" file)) in
	      let lock_call = mkStmtOneInstr(Call (None, lock_func,[], location)) in
	      let unlock_func = Lval (var (FindFunction.find "cbi_atoms_unlock" file)) in
	      let unlock_call = mkStmtOneInstr(Call (None, unlock_func,[], location)) in
	      let on_blk = mkBlock[ lock_call; selector_stmt; bump_cur; execute_stmt; unlock_call; reset_stmt; dummy_sample ] in
(* 	      let on_blk = mkBlock[  selector_stmt; bump_cur; execute_stmt; reset_stmt; dummy_sample ] in *)

(* 	      let on_blk = mkBlock[ selector_stmt;  bump_stmt; execute_stmt;  reset_stmt; dummy_sample ] in *)
	      (on_blk)
	      in
	    

	  let get_if_sampling_blk  location on_blk off_blk default_stmt=
	      let gsample = get_gsample_lval() in
	      let gsample_Lval = Lval gsample in
	      let is_sampling_on =  BinOp (Eq, gsample_Lval, one, intType) in (* is sampling enabled?*) 
	      let if_gsample_stmt = mkStmt( If (is_sampling_on, on_blk , off_blk , location)) in
	      mkBlock [if_gsample_stmt; default_stmt] (*everyone is in here*)
	  in

	  let get_instrumentation location lvals execute_stmt1  orig_instr execute_stmt2 default_stmt =
	    match lvals with [] -> mkBlock[execute_stmt2; default_stmt] 
	    |_ -> 
		let on_blk =  get_on_blk location lvals orig_instr execute_stmt1 in 
		let off_blk = get_off_blk location orig_instr execute_stmt2 in 
		let if_gsample_blk = (get_if_sampling_blk location on_blk off_blk default_stmt) in
		if_gsample_blk 
	  in

	match stmt.skind with
	| Instr[Set(left, expr, location) ] 
	    when self#includedStatement stmt ->
	      (*** used for instrumentation when sampling is ON ***)
	      let lvals = if (skip_lval left) then (get_lvals expr) else left::(get_lvals expr) in
	      let execute_stmt1 =  mkStmtOneInstr (Set(left,expr,location)) in

	      (*** used for instrumentation when sampling is OFF ***)
	      let orig_instr = (Set(left,expr,location)) in 
	      let execute_stmt2 = mkStmtOneInstr (Set(left,expr,location)) in

	      (***statement to be executed after the if block *)
	      let default_stmt = mkEmptyStmt() in

	      let if_gsample_blk = get_instrumentation location lvals execute_stmt1 orig_instr execute_stmt2 default_stmt in

	      stmt.skind <- Block(if_gsample_blk);
	      SkipChildren

	| If(predicate, thenClause, elseClause, location)
	    when self#includedStatement stmt ->
	    let predTemp = var (Locals.makeTempVar func (typeOf predicate)) in
	    let predLval = Lval predTemp in

	    (*** used for instrumentation when sampling is ON ***)
	    let lvals = get_lvals predicate in
	    let execute_stmt1  = mkStmtOneInstr(Set (predTemp, predicate, location)) in

	    (*** used for instrumentation when sampling is OFF ***)
	    let orig_instr  = Set (predTemp, predicate, location) in
	    let execute_stmt2  = mkStmtOneInstr(Set (predTemp, predicate, location)) in

	    (***statement to be executed after the if block *)
	    let default_stmt = mkStmt (If (predLval, thenClause, elseClause, location)) in (*the actual branch instruction *)

	    let if_gsample_blk = get_instrumentation location lvals execute_stmt1 orig_instr execute_stmt2 default_stmt in
	    let replacement = Block (if_gsample_blk) in
	    ChangeDoChildrenPost (stmt, postpatch replacement)

	| Instr( [Call(lhs, Lval callee , args, location)] ) 
	  when self#includedStatement stmt ->
(* 	    if (is_varargs_call callee) then (\* Don't instrument variable argument calls *\) *)
	    (*** used for instrumentation when sampling is ON ***)
	    let lvs = 
	      (match lhs with None-> []
	      | Some(left) -> if (skip_lval left) then []  else [left])
	    in
	    let lvals = list_get_lvals args lvs in

	    (* evaluate each actual argument and store it in a temporary variable *)
	    let argTemps, argTempSets =
	      let argTemp actualExpr =
		let tempVar = var (makeTempVar func (typeOf actualExpr)) in
		Lval tempVar, Set (tempVar, actualExpr, location)
	      in
	      let variables, assignments = List.split (List.map argTemp args) in
	      variables, assignments
	    in
	    let argTempSetsClone () =
	      mkStmt (IsolateInstructions.isolate argTempSets)
	    in

	    (*** used for instrumentation when sampling is OFF ***)
	    let orig_instr = Call(lhs, Lval callee, args, location) in

	    (***statement to be executed after the if block *)
	    let  default_stmt = mkStmtOneInstr(Call(lhs, Lval callee, argTemps, location)) in

	    let if_gsample_blk =
	      get_instrumentation
		location lvals
		(argTempSetsClone ()) orig_instr
		(argTempSetsClone ()) default_stmt
	    in
	    stmt.skind <- Block( if_gsample_blk );
	    SkipChildren


	| Return(exp,location)
	   when self#includedStatement stmt  ->
	     begin 
	       let reset_stmt = get_reset_sampling_stmt location in 
	       let orig_stmt = mkStmt(Return(exp, location)) in
	       stmt.skind <- Block( mkBlock [reset_stmt; orig_stmt ] );
	     end;
	    SkipChildren



	| _ ->
	    DoChildren

    end
