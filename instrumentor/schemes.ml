open Arg


let registry = new StringHash.c 4

let register = registry#replace


let active = new StringHash.c 1

let activate name = active#replace name ()

let _ =
  let spec = "scheme", String activate, "instrumentation scheme to activate" in
  Options.push spec
