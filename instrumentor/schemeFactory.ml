type t = Cil.file -> Scheme.c


let build ~flag ~ident factory =
  let active = Options.registerBoolean
      ~flag: ("scheme-" ^ ident)
      ~desc: ("enable " ^ flag ^ " instrumentation scheme")
      ~ident: ("Scheme" ^ ident)
      ~default: false
  in
  fun file ->
    if !active then factory file
    else NothingScheme.factory file
