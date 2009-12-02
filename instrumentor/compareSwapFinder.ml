open Cil
open Helpers
open Interesting

let postpatch replacement statement =
  statement.skind <- replacement;
  statement


let isInterestingVar  = isInterestingVar  isDiscreteType
let isInterestingLval = isInterestingLval isDiscreteType


class visitor file =
  let sampling_count_func  = Lval (var (FindFunction.find "cbi_compareSwap_sampling_count" file)) in

  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method vstmt stmt =

	match stmt.skind with
	| Instr [Set (left, right, _) as instr]
	  when self#includedStatement stmt ->
	    begin
	      match SharedAccesses.isolated instr with
	      | Some lval when not (is_bitfield lval) ->
                begin


		  (*match (isDiscreteType (typeOfLval lval) || isFloatType (typeOfLval lval)) with*)
		  match (isDiscreteType (typeOfLval lval)) with
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

			let cmpswp_stmts =
			  let isDifferent = var (findOrCreate_local_type func "cbi_isDifferent" intType) in
			  let isStale =  var (findOrCreate_local_type func "cbi_isStale" intType) in
			  let isFound =  var (findOrCreate_local_type func "cbi_isFound" intType) in
			  let isCur = UnOp (LNot, Lval isStale, intType) in
			  let test_set_func = Lval (var (FindFunction.find "cbi_dict_test_and_insert" file)) in
			  let test_set_args = [Cil.mkCast (mkAddrOrStartOf lval) Cil.ulongType;
					       Cil.mkCast (Lval lval) Cil.ulongType;
					       mkAddrOf isDifferent;
					       mkAddrOf isStale]
			  in
			  let test_set_call = Call (Some isFound, test_set_func, test_set_args, !currentLoc) in
			  let different_index = BinOp(LAnd, Lval isFound, Lval isDifferent, intType) in


			  let insert_call = 
			    if left == lval then
			      let insert_func = Lval (var (FindFunction.find "cbi_dict_insert" file)) in
			      let insert_args = [Cil.mkCast (mkAddrOrStartOf lval) Cil.ulongType;
				                 Cil.mkCast right Cil.ulongType]
			      in
                              mkStmtOneInstr (Call (None, insert_func, insert_args, !currentLoc))
                            else
                              mkEmptyStmt()
                          in

			  let set_stmts =[ mkStmtOneInstr (Call (None, sampling_count_func, [], !currentLoc));
			                   mkStmtOneInstr test_set_call;
			                   mkStmt (If (isCur,
				                   mkBlock [mkStmtOneInstr (fst (tuples#addExpr different_index))],
				                   mkBlock [mkEmptyStmt()],
				                   !currentLoc));
                                           mkStmtOneInstr (fst (tuples#addExpr different_index));
                                           insert_call]
                          in
			  let sampled_stmt = tuples#addSiteStmts (siteInfo ()) set_stmts in
			  [sampled_stmt; mkStmtOneInstr instr]
			in

			stmt.skind <- Block (mkBlock (cmpswp_stmts))

                end

	      | Some _
	      | None ->
		  ()
	    end;
	    SkipChildren

	| _ ->
	    DoChildren

    end
