open Calls
open Cil
open Interesting
open Invariant


class visitor file =
  let invariant = invariant file in

  fun global func ->
    let invariant = invariant func in

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
		let left = {
		  exp = Lval result;
		  name = Pretty.sprint max_int (d_exp () callee)
		} in
		let right = { exp = zero; name = "0" } in
		let (site, global) = invariant location left right in
		sites <- info.site :: sites;
		self#addGlobal global;
		let call = mkStmt stmt.skind in
		info.site.skind <- site;
	      end;
	    SkipChildren

	| _ ->
	    super#vstmt stmt
    end
