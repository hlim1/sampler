open Cil


let idents = ref []


let register ident =
  idents := ident :: !idents


let phase file =
  let element = TInt (IChar, [Attr ("const", [])]) in
  let typ = TArray (element, None, [Attr ("unused", [])]) in
  let varinfo = makeGlobalVar "samplerIdent" typ in
  varinfo.vstorage <- Static;

  let text =
    let folder prefix (name, renderer) =
      prefix ^ "$Sampler" ^ name ^ ": " ^ renderer () ^ " $"
    in
    List.fold_left folder "" !idents
  in

  let init = SingleInit (mkString text) in
  let global = GVar (varinfo, { init = Some init }, locUnknown) in
  file.globals <- global :: file.globals
