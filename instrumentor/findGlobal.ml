open Cil


let find name {globals = globals} =
  let rec findAmong = function
    | GVarDecl ({vtype = TFun _} as varinfo, _) :: rest ->
	findAmong rest
    | GVarDecl ({vname = vname} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | GVar ({vname = vname} as varinfo, _, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing.Missing name)
  in
  findAmong globals
