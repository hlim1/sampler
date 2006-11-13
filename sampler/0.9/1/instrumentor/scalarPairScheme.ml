open Cil
open Interesting
open SchemeName


let name = {
  flag = "scalar-pairs";
  prefix = "scalarPairs";
  ident = "ScalarPairs";
}


class c file : Scheme.c =
  object (self)
    val tuples = new Counters.manager name file

    val constants = Constants.collect file
    val mutable globals = []

    method findAllSites =
      TestHarness.time ("  finding " ^ name.flag ^ " sites")
	(fun () ->
	  let scanner = function
	    | GVar (varinfo, _, _)
	    | GVarDecl (varinfo, _)
	      when isInterestingVar varinfo ->
		globals <- varinfo :: globals
	    | GFun (func, _) ->
		let finder = new ScalarPairFinder.visitor constants globals tuples func in
		ignore (Cil.visitCilFunction finder func)
	    | _ ->
		()
	  in
	  iterGlobals file scanner);
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
