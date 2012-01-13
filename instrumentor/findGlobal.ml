open Cil


let find name {globals; _} =
  let rec findAmong = function
    | GVarDecl ({vtype = TFun _; _}, _) :: rest ->
	findAmong rest
    | GVarDecl ({vname; _} as varinfo, _) :: _
      when vname = name ->
	varinfo
    | GVar ({vname; _} as varinfo, _, _) :: _
      when vname = name ->
	varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing.Missing name)
  in
  findAmong globals


let findInit name {globals; _} =
  let rec findAmong = function
    | GVar ({vname; _}, initinfo, _) :: _
      when vname = name ->
	initinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing.Missing name)
  in
  findAmong globals
