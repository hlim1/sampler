open Calls
open Cil
open Interesting
open Invariant


class visitor file =
  let invariant = invariant file in

  fun func ->
    let invariant = invariant func in

    object
      inherit Classifier.visitor as super

      val mutable sites = []
      method sites = sites

      val mutable globals = []
      method globals = globals

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
		globals <- global :: globals;
		let call = mkStmt stmt.skind in
		info.site.skind <- site;
	      end;
	    SkipChildren

	| _ ->
	    super#vstmt stmt
    end
