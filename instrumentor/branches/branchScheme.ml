class c file =
  object
    inherit Scheme.c file

    val finder = new BranchFinder.visitor

    method findSites func =
      ignore (Cil.visitCilFunction finder func)

    method embedInfo _ =
      BranchSite.embedInfo
  end


let register = Instrumentor.addScheme new c
