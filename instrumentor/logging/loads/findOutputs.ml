open Cil
open OutputSet


class visitor outputs =
  object
    inherit nopCilVisitor

    method vexpr = function
      | Lval lval ->
	  Dissect.dissect lval (typeOfLval lval) outputs;
	  DoChildren
      | SizeOfE _ ->
	  SkipChildren
      | _ ->
	  DoChildren
  end


let collect instr =
  let outputs = new OutputSet.container in

  let descend visit root =
    let visitor = new visitor outputs in
    ignore (visit visitor root)
  in

  begin
    match instr with
    | Return (Some expression, _)
    | If (expression, _, _, _) ->
	descend visitCilExpr expression
    | Instr [instruction] ->
	descend visitCilInstr instruction
    | Instr _ ->
	failwith "instr should have been atomized"
    | Switch _ ->
	failwith "switch should have been removed by Cil.prepareCFG"
    | _ ->
	()
  end;
  outputs
