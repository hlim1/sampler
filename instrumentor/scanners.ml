open Cil


let iterFuncs file action =
  let visitor = function
    | GFun (fundec, location) -> action (fundec, location)
    | _ -> ()
  in
  iterGlobals file visitor
