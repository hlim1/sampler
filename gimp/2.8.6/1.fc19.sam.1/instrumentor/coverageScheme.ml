open SchemeName


let name = {
  flag = "coverage";
  prefix = "coverage";
  code = "V";
  ident = "Coverage";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file

    method private findAllSites =
      Scanners.iterFuncs file
	(fun func ->
	  let finder = new CoverageFinder.visitor tuples func in
	  ignore (Cil.visitCilFunction finder func));
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
