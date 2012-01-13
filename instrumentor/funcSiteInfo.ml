open Cil
open Pretty

(*cci*)
class c func inspiration =
  object
    inherit SiteInfo.c func inspiration as super

    method! print =
      super#print @ [text func.svar.vname]
  end
