open Cil

  
let count_instr = function
  | Set((Mem(_), _), _, _) -> 1
  | _ -> 0
	
	
let rec count_stmt {skind = skind} =
  match skind with
  | Instr(instrs) ->
      List.fold_left
	(fun subtotal instr -> subtotal + count_instr instr)
	0 instrs
  | _ -> 0
	
