let name = "returns"


class c file =
  object
    inherit Scheme.c file

    val tuples = CounterTuples.build name file

    method private findSites func =
      StoreReturns.visit func;
      let finder = new ReturnFinder.visitor tuples func in
      ignore (Cil.visitCilFunction finder func)

    method embedInfo = tuples#finalize
  end


let factory = SchemeFactory.build ~flag:name ~ident:"Returns" new c
