open Cil
open Interesting
open SchemeName


let name = {
  flag = "scalar-pairs";
  prefix = "scalarPairs";
  ident = "ScalarPairs";
}


class c file =
  object (self)
    inherit Scheme.c name file

    val tuples = CounterTuples.build name file

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
		self#findSites func
	    | _ ->
		()
	  in
	  iterGlobals file scanner)

    method private findSites func =
      let finder = new ScalarPairFinder.visitor constants globals tuples func in
      ignore (Cil.visitCilFunction finder func)

    method embedInfo = tuples#finalize
  end


let factory = SchemeFactory.build name new c
