open Cil


exception Found


let visit file digest =
  try
    let initinfo = FindGlobal.findInit "samplerUnitSignature" file in
    let signature = Lazy.force digest in
    let expr = mkString signature in
    initinfo.init <- Some (SingleInit expr)
  with
    Not_found -> ()
