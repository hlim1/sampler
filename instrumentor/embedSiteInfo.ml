open Cil


let accumulator = new BufferClass.c 0


let visit file =
  try
    let initinfo = FindGlobal.findInit "samplerSiteInfo" file in
    initinfo.init <- Some (SingleInit (mkString accumulator#contents))
  with
    Missing.Missing _ -> ()
