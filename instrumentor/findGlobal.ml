open Cil


exception Missing of string


let find predicate name {globals = globals} =
  let rec findAmong = function
    | GVarDecl ({vname = vname; vtype = vtype} as varinfo, _) :: _
      when vname = name && predicate vtype ->
	var varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise (Missing name)
  in
  findAmong globals
