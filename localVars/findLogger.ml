open Cil


let find file =
  let rec findAmong = function
    | GVarDecl ({vname = "logVars"; vtype = TFun _} as varinfo, _) :: _ ->
	Lval (var varinfo)
    | _ :: rest ->
	findAmong rest
    | [] ->
	raise Not_found
  in
  findAmong file.globals
