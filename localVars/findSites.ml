open Cil


let collect fundec =
  let outputs = Collect.collect fundec in
  
  function
    | Instr [_] ->
	outputs
    | _ ->
	OutputSet.OutputSet.empty
