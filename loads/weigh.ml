open Cil


let weigh {skind = skind} =
  match skind with
  | Instr instrs ->
      List.length instrs
  | _ ->
      0
