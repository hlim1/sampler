open Cil


exception Missing of string


let find name file =

  let lval =
    let rec findAmong = function
      | GFun ({svar = {vname = vname} as varinfo}, _) :: _
	when vname = name ->
	  var varinfo
      | GFun ({svar = {vname = vname; vinline = true} as varinfo}, _) :: _
	when vname = name ^ "__extinline" ->
	  var varinfo
      | GVarDecl ({vname = vname; vtype = TFun _} as varinfo, _) :: _
	when vname = name ->
	  var varinfo
      | _ :: rest ->
	  findAmong rest
      | [] ->
	  raise (Missing name)
    in
    findAmong file.globals
  in
  Lval lval
