open Cil


let collect = function
  | Instr [Set((Mem address, NoOffset), Lval data, location)] ->
      Dissect.dissect data (typeOfLval data)
  | _ ->
      OutputSet.OutputSet.empty
