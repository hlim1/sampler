open Cil

  
let count_stores_instr = function
  | Set((Mem(_), _), _, _) -> 1
  | _ -> 0
	
	
let rec count_stores_stmt {skind = skind} =
  let sum metric =
    List.fold_left (fun subtotal thing -> subtotal + metric thing) 0
  in
  
  match skind with
  | Instr(instrs) ->
      sum count_stores_instr instrs
  | Block({bstmts = bstmts}) ->
      sum count_stores_stmt bstmts
  | _ -> 0
