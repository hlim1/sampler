open Cil


let weigh {skind = skind} =
  match skind with
  | Instr instrs ->
      let folder subtotal = function
	| Set _
	| Call (Some _, _, _, _) ->
	    subtotal + 1
	| _ ->
	    subtotal
      in
      List.fold_left folder 0 instrs
  | _ ->
      0
