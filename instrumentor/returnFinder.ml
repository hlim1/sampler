open Cil
open InterestingReturn


class visitor (tuples : Counters.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method vstmt stmt =
      match IsolateInstructions.isolated stmt with
      | Some (Call (Some result, callee, args, location))
	when self#includedStatement stmt
	    && isInterestingCallee callee ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    begin
	      let exp = Lval result in
	      let desc = d_exp () callee in
	      let compare op = BinOp (op, exp, zero, intType) in
	      let selector = Index (BinOp (PlusA, compare Gt, compare Ge, intType), NoOffset) in
	      let bump = tuples#addSite func selector (d_exp () callee) location in
	      stmt.skind <- Block (mkBlock [mkStmt stmt.skind; bump]);
	    end;
	  SkipChildren

      | _ ->
	  DoChildren
  end
