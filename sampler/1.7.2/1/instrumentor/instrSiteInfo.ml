open Cil
open Pretty

(*cci*)
class c func inspiration instruction =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      super#print @ [dn_instr () instruction]
  end
