open Cil


let collect instr =
  let outputs = new OutputSet.container in
  begin
    match instr with
    | Instr [Set (lval, _, location)]
    | Instr [Call (Some lval, _, _, location)] ->
	Dissect.dissect lval (typeOfLval lval) outputs
    | Instr [Call (None, _, _, _)]
    | Instr [] ->
	()
    | Instr _ ->
	currentLoc := get_stmtLoc instr;
	ignore (bug "instr should have been atomized")
    | _ ->
	()
  end;
  outputs
