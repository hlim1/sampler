open Cil


class visitor logger fundec = object
  inherit Sites.visitor

  val outputs = Collect.collect fundec

  method consider = function
    | Instr [instruction] ->
	let location = get_instrLoc instruction in
	logger location outputs
    | _ ->
	[]
end
