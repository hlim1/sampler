open Cil
open Arg


let options = [
  "remove-dead-code", TransformVisitor.removeDeadCode, "remove dead code", "RemoveDeadCode";
  "specialize-empty-regions", Countdown.specializeEmptyRegions, "specialize countdown checks for regions with no sampling sites", "SpecializeEmptyRegions";
  "specialize-singleton-regions", Countdown.specializeSingletonRegions, "specialize countdown checks for regions with exactly one sampling site", "SpecializeSingletonRegions"
]


let argspecs =
  let extract specs (flag, value, desc, _) =
    ("--" ^ flag, Set value, desc ^ " [default]")
    :: ("--no-" ^ flag, Clear value, "")
    :: specs
  in
  List.fold_left extract [] options


let phase =
  "Options",
  (fun file ->

    let element = TInt (IChar, [Attr ("const", [])]) in
    let typ = TArray (element, None, [Attr ("unused", [])]) in
    let varinfo = makeGlobalVar "samplerIdent" typ in
    varinfo.vstorage <- Static;

    let text =
      let folder prefix (_, value, _, name) =
	prefix ^ "$Sampler" ^ name ^ ": " ^ string_of_bool !value ^ " $"
      in
      List.fold_left folder "" options
    in

    let init = SingleInit (mkString text) in
    let global = GVar (varinfo, Some init, locUnknown) in
    file.globals <- global :: file.globals)
