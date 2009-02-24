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

	match stmt.skind with
        (*TODO: instrument functions too...*)
	| Instr [(Set (left, expr, location)) ]
	    when self#includedStatement stmt ->
	      begin 
		if (isInterestingLval  file left || isInterestingExp  file expr) 
		then 
		  begin

		    let gsample = var (findOrCreate_global file ( (get_prefix func file)^"_gsample")) in
		    let gsample_Lval = Lval gsample in

		    let iset = var (findOrCreate_local func ("cbi_iSet")) in
		    let iset_Lval = Lval iset in
		    
		    (*bump + orig*)
		    let orig  = Set(left, expr, location) in
		    let cur_tid = var (findOrCreate_local func "cbi_tid_temp") in
		    let bump_selector = BinOp(Eq, iset_Lval, one, intType) in 
		    let cur_tid_Lval = Lval cur_tid in
		    let tid_func = Lval (var (FindFunction.find "cbi_thread_self" file)) in
		    let init_cur_tid = Call (Some(cur_tid), tid_func, [], location) in (* TODO only call once at start of function*)
		    let prev_tid = var (findOrCreate_global file ( (get_prefix func file)^"_prev_tid") ) in
		    let prev_tid_Lval = Lval prev_tid  in
		    let selector = BinOp (Ne, cur_tid_Lval, prev_tid_Lval, intType) in
		    let set_prev_tid =  (Set (prev_tid, cur_tid_Lval, location)) in
		    let siteInfo = new InstrSiteInfo.c func location orig in
		    let bump,_ = tuples#addExpr selector in

		    let bump_blk = make_block[ init_cur_tid; bump] in
		    let set_blk = make_block [ set_prev_tid] in
		    let if_iset_skind = If( bump_selector, bump_blk, set_blk, location) in
		    let if_iset_stmt = mkStmt (if_iset_skind) in
		    let orig_stmt = mkStmtOneInstr orig in
 		    (* let bump_orig_blk = make_block [init_cur_tid; bump; set_prev_tid; orig ] in  *)
		    let bump_orig_blk = mkBlock [ if_iset_stmt; orig_stmt] in

		    let orig_blk = make_block [orig] in
 		    let enabled = BinOp (Eq, gsample_Lval, one, intType) in (* is sampling enabled?*) 
		    let if_gsample_skind = If (enabled, bump_orig_blk, orig_blk, location) in
		    let if_gsample_stmt = mkStmt ( if_gsample_skind) in
		    let if_gsample_blk = mkBlock [if_gsample_stmt] in (*everyone is in here*)

                      (*resetting sample + local site id *)
		    let reset_gsample = Set(gsample, zero, location) in
		    let reset_iset = Set(iset, zero, location) in
		    let reset_blk = make_block [reset_gsample; reset_iset] in
		    let empty_blk = mkBlock[ mkEmptyStmt() ] in
                      
                      let temp_expr_1 = BinOp(Eq, gsample_Lval, one, intType) in
                      let temp_var_1 =  var(findOrCreate_local func "g_sampled_temp_var_1") in
                      let set_cond_1 = mkStmtOneInstr(Set(temp_var_1, temp_expr_1, location)) in

                      let temp_expr_2 = BinOp(Eq, iset_Lval, one, intType) in
                      let temp_var_2 = var(findOrCreate_local func "g_sampled_temp_var_2") in
                      let set_cond_2 = mkStmtOneInstr( Set(temp_var_2, temp_expr_2, location)) in
		    (*TODO: we need a lock around the reset code as well *)

		    let reset_cond = BinOp(LAnd, Lval(temp_var_1),  Lval(temp_var_2), intType ) in
		    let if_reset_stmt = mkStmt ( If(reset_cond,reset_blk, empty_blk, location )) in
		    

		    (* setting sample flag + local site id*)
		    let yield_func = Lval (var (FindFunction.find "cbi_atoms_yield" file)) in
		    let yield_call = Call(None, yield_func, [], location) in (* yield here, so we don't have to use the yields scheme*)

		    let set_gsample = ( Set(gsample, one, location)) in
		    let set_iset =  (Set(iset, one, location)) in
		    let init_prev_tid = Call (Some(prev_tid), tid_func, [], location) in (* TODO only call once at start of function*)
		    let thump = tuples#addSiteInstrs siteInfo [set_gsample; set_iset; init_prev_tid; yield_call] in 
		    let set_blk = mkBlock [thump] in
		    let empty_blk = mkBlock[ mkEmptyStmt() ] in
 		    let set_gsample_stmt = mkStmt(If( (BinOp(Ne, gsample_Lval, one, intType ) ), set_blk, empty_blk, location))  in 

		    let big_blk = mkBlock[ mkStmt(Block(if_gsample_blk)); set_cond_1;  set_cond_2; if_reset_stmt; set_gsample_stmt] in
		    stmt.skind <- Block(big_blk);

		  end;
	      end;
	      SkipChildren

	| Return(exp,location)
	   when self#includedStatement stmt  ->
	     begin 
	       let gsample = var (findOrCreate_global file ( (get_prefix func file)^"_gsample")) in
	       let iset = var (findOrCreate_local func ("cbi_iSet")) in
	       let iset_Lval = Lval iset in
	    
	       let empty_blk = mkBlock[ mkEmptyStmt() ] in
	       let reset_gsample_blk =  make_block [(Set(gsample, zero, location))] in
	       let cond = BinOp(Eq, iset_Lval, one, intType) in
	       let if_blk = mkStmt(If(cond, reset_gsample_blk, empty_blk, location)) in
	       let orig_stmt = mkStmt(Return(exp, location)) in
	       stmt.skind <- Block( mkBlock [if_blk; orig_stmt ] );
	     end;
	    SkipChildren

	| _ ->
	    DoChildren

    end
