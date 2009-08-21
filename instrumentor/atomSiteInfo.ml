open Cil
open Pretty


class c func inspiration instruction =
  object
    inherit InstrSiteInfo.c func inspiration instruction as super

    method print =
      let prevStyle = !lineDirectiveStyle in
      lineDirectiveStyle := None;
      let result = super#print @ [descriptiveCilPrinter#pInstr () instruction] in
      lineDirectiveStyle := prevStyle;
      result
  end
