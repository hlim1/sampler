open Cil
open InterestingReturn


class visitor (tuples : CounterTuples.manager) func =
  object (self)
    inherit SiteFinder.visitor

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (Some result, callee, args, location)]
	when self#includedStatement stmt ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    begin
	      let exp = Lval result in
	      let desc = d_exp () callee in
	      let compare op = BinOp (op, exp, zero, intType) in
	      let selector = BinOp (PlusA, compare Gt, compare Ge, intType) in
	      let bump = tuples#addSite func selector (d_exp () callee) location in
	      stmt.skind <- Block (mkBlock [mkStmt stmt.skind; bump]);
	    end;
	  SkipChildren

      | Instr (_ :: _ :: _) ->
	  ignore (bug "instr should have been atomized");
	  failwith "internal error"

      | _ ->
	  DoChildren
  end
