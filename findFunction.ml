open Cil


let find name file =
  let predicate = function
    | {vname = vname; vtype = TFun _} when vname = name -> true
    | _ -> false
  in
  Lval (FindGlobal.find predicate file)
