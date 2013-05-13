open SchemeName

(*cci*)
let name = {
  flag = "compare-swap";
  prefix = "compareSwap";
  code = "C";
  ident = "CompareSwap";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file 

    method private findAllSites =
      let finder = new CompareSwapFinder.visitor file tuples in
      Scanners.iterFuncs file
	(fun func ->
	  let finder = finder func in
	  ignore (Cil.visitCilFunction finder func  ));

        tuples#patch  

    method saveSiteInfo = tuples#saveSiteInfo 
  end


let factory = SchemeFactory.build name new c
