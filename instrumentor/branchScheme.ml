open SchemeName


let name = {
  flag = "branches";
  prefix = "branches";
  ident = "Branches";
}


class c file : Scheme.c =
  object
    val tuples = new CounterTuples.manager name file

    method private findAllSites =
      Scanners.iterFuncs file
	(fun func ->
	  let finder = new BranchFinder.visitor tuples func in
	  ignore (Cil.visitCilFunction finder func));
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
