open Cil


class visitor logger = object
  inherit Sites.visitor

  method consider = function
    | Instr [Set (lval, _, location)]
    | Instr [Call (Some lval, _, _, location)] ->
	logger location (Dissect.dissect lval (typeOfLval lval))
    | _ ->
	[]
end
