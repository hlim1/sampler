open Calls
open Cil
open Interesting


class visitor (tuples : ReturnTuples.builder) global func =
  object (self)
    inherit Classifier.visitor global as super

    val mutable sites = []
    method sites = sites

    method vstmt stmt =
      match stmt.skind with
      | Instr [Call (Some result, callee, args, location)] ->
	  let info = super#prepatchCall stmt in
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    begin
	      let exp = Lval result in
	      let desc = d_exp () callee in
	      let bump = tuples#bump func location exp desc in
	      sites <- info.site :: sites;
	      let call = mkStmt stmt.skind in
	      info.site.skind <- bump;
	    end;
	  SkipChildren

      | _ ->
	  super#vstmt stmt
  end
