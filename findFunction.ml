open Cil


let find name =
  let predicate = function
    | {vname = vname; vtype = TFun _} when vname = name -> true
    | _ -> false
  in
  FindGlobal.find predicate
