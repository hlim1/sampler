open Cil


exception Missing of string


let find name {globals = globals} =
  let rec findAmong = function
    | GVarDecl ({vname = vname} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | GVar ({vname = vname} as varinfo, _, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in
  findAmong globals
