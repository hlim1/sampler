open Cil
open Interesting


let name = "scalar-pairs"


class c file =
  object (self)
    inherit Scheme.c file

    val tuples = CounterTuples.build name file

    val constants = Constants.collect file
    val mutable globals = []

    method findAllSites =
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
      iterGlobals file scanner

    method private findSites func =
      let finder = new ScalarPairFinder.visitor constants globals tuples func in
      ignore (Cil.visitCilFunction finder func)

    method embedInfo = tuples#finalize
  end


let factory = SchemeFactory.build ~flag:name ~ident:"ScalarPairs" new c
