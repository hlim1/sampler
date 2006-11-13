open Cil


let empty = new OutputSet.container


let select outputs = function
  | Instr [_] ->
      outputs
  | Instr _ ->
      failwith "instr should have been atomized"
  | _ ->
      empty
