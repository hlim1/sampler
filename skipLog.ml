open Cil
  

type closure = location -> instr

let find file =
  let func = FindFunction.find "skipLog" file in
  fun location -> Call (None, func, [], location)
