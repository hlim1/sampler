open Cil


let find predicate {globals = globals} =
  let rec findAmong = function
    | GVarDecl (varinfo, _) :: _ when predicate varinfo ->
	var varinfo
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise Not_found
  in
  findAmong globals
