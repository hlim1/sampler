open Cil


let find name file =

  let lval =
    let rec findEither = function
      | GFun ({svar = {vname = vname; vinline = true} as varinfo}, _) :: _
	when vname = name ^ "__extinline" ->
	  var varinfo
      | _ :: rest ->
	  findEither rest
      | [] ->
	  let predicate = function
	    | TFun _ -> true
	    | _ -> false
	  in
	  FindGlobal.find predicate name file
    in
    findEither file.globals
  in
  Lval lval
