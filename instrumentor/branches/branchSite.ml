open Cil


class c stmt (predicate, _, _, location) =
  object
    inherit Site.c

    method enact =
      
  end


let siteInfo = FindGlobal.find "branchesSiteInfo" file in
