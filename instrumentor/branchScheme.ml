open SchemeName


let name = {
  flag = "branches";
  prefix = "branches";
  ident = "Branches";
}


class c file =
  object
    inherit Scheme.c name file

    val tuples = CounterTuples.build name file

    method private findSites func =
      let finder = new BranchFinder.visitor tuples func in
      ignore (Cil.visitCilFunction finder func)

    method embedInfo = tuples#finalize
  end


let factory = SchemeFactory.build name new c
