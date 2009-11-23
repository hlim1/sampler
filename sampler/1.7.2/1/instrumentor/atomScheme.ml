open SchemeName
open Cil

(*cci*)
let name = {
  flag = "atoms";
  prefix = "atoms";
  ident = "Atoms";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file 

    method private findAllSites =
      let finder = new AtomFinder.visitor file tuples (* b_varinfo *) in
      Scanners.iterFuncs file
	(fun func ->
	  let finder = finder func in
	  ignore (Cil.visitCilFunction finder func  ));

      tuples#patch  

    method saveSiteInfo = tuples#saveSiteInfo 
  end


let factory = SchemeFactory.build name new c
