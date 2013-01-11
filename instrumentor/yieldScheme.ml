open SchemeName

(*cci*)
let name = {
  flag = "yields";
  prefix = "yields";
  code = "Y";
  ident = "Yields";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file 

    method private findAllSites =
      let finder = new YieldFinder.visitor file tuples in
      Scanners.iterFuncs file
	(fun func ->
	  let finder = finder func in
	  ignore (Cil.visitCilFunction finder func));
        tuples#patch  

    method saveSiteInfo = tuples#saveSiteInfo 
  end


let factory = SchemeFactory.build name new c
