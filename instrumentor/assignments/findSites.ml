open Cil


let collect = function
  | Instr [Set (lval, _, location)]
  | Instr [Call (Some lval, _, _, location)] ->
      Dissect.dissect lval (typeOfLval lval)
  | _ ->
      OutputSet.OutputSet.empty
