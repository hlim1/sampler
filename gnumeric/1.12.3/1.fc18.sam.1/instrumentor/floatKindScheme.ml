open SchemeName


let name = {
  flag = "float-kinds";
  prefix = "floatKinds";
  code = "F";
  ident = "FloatKinds";
}


class c file : Scheme.c =
  object
    val tuples = new Counters.manager name file

    val classifier = FloatKindFinder.classifier file

    method findAllSites =
      TestHarness.time ("finding " ^ name.flag ^ " sites")
	(fun () ->
	  let scanner func =
	    let finder = new FloatKindFinder.visitor classifier tuples func in
	    ignore (Cil.visitCilFunction finder func)
	  in
	  Scanners.iterFuncs file scanner);
      tuples#patch

    method saveSiteInfo = tuples#saveSiteInfo
  end


let factory = SchemeFactory.build name new c
