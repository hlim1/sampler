open Calls
open Cil
open DescribedExpression
open Interesting


class visitor (tuples : ReturnTuples.builder) func =
  object (self)
    inherit Classifier.visitor func as super

    method private normalize =
      StoreReturns.visit func;
      super#normalize

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (Some result, callee, args, location)]
	when self#includedStatement stmt ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    begin
	      let exp = Lval result in
	      let desc = d_exp () callee in
	      let site = mkEmptyStmt () in
	      let bump = tuples#bump func location site { exp = exp; doc = desc } in
	      site.skind <- bump;
	      sites <- site :: sites;
	      let call = mkStmt stmt.skind in
	      stmt.skind <- Block (mkBlock [call; site])
	    end;
	  SkipChildren

      | Instr (_ :: _ :: _) ->
	  ignore (bug "instr should have been atomized");
	  failwith "internal error"

      | _ ->
	  DoChildren
  end
