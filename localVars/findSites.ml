open Cil


class visitor logger fundec = object
  inherit Sites.visitor

  method consider = function
    | Instr [instruction] ->
	let location = get_instrLoc instruction in
	let instrumentation = Logs.build logger fundec location in
	Some instrumentation
    | _ ->
	None
end
