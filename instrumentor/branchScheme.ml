let name = "branches"


class c file =
  object
    inherit Scheme.c file

    val tuples = CounterTuples.build name file

    method private findSites func =
      let finder = new BranchFinder.visitor tuples func in
      ignore (Cil.visitCilFunction finder func)

    method embedInfo = tuples#finalize
  end


let register () = Schemes.register name new c
