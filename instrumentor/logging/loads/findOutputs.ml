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
  let visitor = new visitor outputs in
  ignore (visit visitCilInstr instr);
  outputs
