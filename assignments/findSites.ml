open Cil


class visitor logger = object
  inherit Sites.visitor

  method consider = function
    | Instr [Set (lval, _, location)]
    | Instr [Call (Some lval, _, _, location)] ->
	let instrumentation = Logs.build logger lval location in
	Some instrumentation
    | _ ->
	None
end
