open Cil


let find name =
  let predicate = function
    | {vname = name; vtype = TFun _} -> true
    | _ -> false
  in
  FindGlobal.find predicate
