open Cil


exception Missing of string


let find name file =
  let predicate = function
    | {vname = vname; vtype = TFun _} when vname = name -> true
    | _ -> false
  in
  try Lval (FindGlobal.find predicate file)
  with Not_found -> raise (Missing name)
