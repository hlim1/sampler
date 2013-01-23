open SchemeName


let name = {
  flag = "data";
  prefix = "data";
  code = "I";
  ident = "Data";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file 

    method private findAllSites =
      Scanners.iterFuncs file
	(fun func ->
	  let finder = new DataFinder.visitor tuples func in
	  ignore (Cil.visitCilFunction finder func));
      tuples#patch  

    method saveSiteInfo = tuples#saveSiteInfo 
  end


let factory = SchemeFactory.build name new c
