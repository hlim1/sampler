open Cil


class visitor logger = object
  inherit Sites.visitor

  method consider = function
    | Instr [Set((Mem address, NoOffset), Lval data, location)] ->
	logger location (Dissect.dissect data (typeOfLval data))
    | _ ->
	[]
end
