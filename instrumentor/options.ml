open Cil
open Arg


let args = ref []
let idents = ref []


let registerBoolean ~flag ~desc ~ident value =
  args :=
    ("--" ^ flag, Set value, desc)
    :: ("--no-" ^ flag, Clear value, "")
    :: !args;
  idents := (ident, fun () -> string_of_bool !value) :: !idents


let registerString ~flag ~desc ~ident value =
  args :=
    ("--" ^ flag, String (fun arg -> value := arg), desc)
    :: !args;
  idents := (ident, fun () -> !value) :: !idents


let argspecs () = !args


let phase =
  "Options",
  (fun file ->

    let element = TInt (IChar, [Attr ("const", [])]) in
    let typ = TArray (element, None, [Attr ("unused", [])]) in
    let varinfo = makeGlobalVar "samplerIdent" typ in
    varinfo.vstorage <- Static;

    let text =
      let folder prefix (ident, value) =
	prefix ^ "$Sampler" ^ ident ^ ": " ^ value () ^ " $"
      in
      List.fold_left folder "" !idents
    in

    let init = SingleInit (mkString text) in
    let global = GVar (varinfo, Some init, locUnknown) in
    file.globals <- global :: file.globals)
