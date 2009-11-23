open Cil
open Helpers

let postpatch replacement statement =
  statement.skind <- replacement;
  statement

class visitor file =
  fun (tuples : Counters.manager) func ->
    object (self)
      inherit SiteFinder.visitor

      method vfunc func =
        if self#includedFunction func && self#includedFile func.svar.vdecl.file then
          let body = func.sbody in
          let cci_inc_counter_func = Lval (var (FindFunction.find "cci_atomicIncrementCounter" file)) in
          let predTemp = var (findOrCreate_global file ((func.svar.vname)^"_entry_counter_"^(get_prefix_file file))) in
          let cci_inc_counter_call = mkStmtOneInstr(Call (None, cci_inc_counter_func,[mkAddrOrStartOf predTemp], func.svar.vdecl)) in
          let predLval = Lval predTemp in
          let selector = BinOp (Ne, predLval, one, intType) in
	  let siteInfo = new FuncSiteInfo.c func func.svar.vdecl in
	  let bump, _ = tuples#addSiteExpr siteInfo selector in
          body.bstmts <- cci_inc_counter_call :: bump :: body.bstmts;
          DoChildren
        else
	  SkipChildren

      method vstmt stmt =
        match stmt.skind with
          | Return(exp,location) ->
              let cci_dec_counter_func = Lval (var (FindFunction.find "cci_atomicDecrementCounter" file)) in
              let predTemp = var (findOrCreate_global file ((func.svar.vname)^"_entry_counter_"^(get_prefix_file file))) in
              let cci_dec_counter_call = mkStmtOneInstr(Call (None, cci_dec_counter_func,[mkAddrOrStartOf predTemp], location)) in
              let orig_stmt = mkStmt(Return(exp, location)) in
              stmt.skind <- Block( mkBlock [cci_dec_counter_call; orig_stmt ] );
              SkipChildren
          | _ ->
              DoChildren
  end
