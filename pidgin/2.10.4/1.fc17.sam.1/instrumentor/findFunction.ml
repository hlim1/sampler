open Cil


exception Missing of string


let find name file =

  let rec findAmong = function
    | GFun ({svar = {vname; _} as varinfo; _}, _) :: _
      when vname = name ->
	varinfo
    | GFun ({svar = {vname; vinline = true; _} as varinfo; _}, _) :: _
      when vname = name ^ "__extinline" ->
	varinfo
    | GVarDecl ({vname; vtype = TFun _; _} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in

  findAmong file.globals


let findDefinition name file =

  let rec findAmong = function
    | GFun ({svar = {vname; _}; _} as fundec, _) :: _
      when vname = name ->
	fundec
    | GFun ({svar = {vname; vinline = true; _}; _} as fundec, _) :: _
      when vname = name ^ "__extinline" ->
	fundec
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in

  findAmong file.globals
