open Cil


let collect instr =
  let outputs = new OutputSet.container in
  begin
    match instr with
    | Instr [Set((Mem address, NoOffset), Lval data, location)] ->
	Dissect.dissect data (typeOfLval data) outputs
    | _ ->
	()
  end;
  outputs
