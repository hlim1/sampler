open Cil


class visitor = object
  inherit Sites.visitor

  method consider = function
    | Instr [Set((Mem address, NoOffset), Lval data, location)] ->
	let instrumentation = Instrument.build address data location in
	Some instrumentation
    | _ ->
	None
end
