open Cil


class visitor = object
  inherit nopCilVisitor

  val lvals = ref []
  method result = !lvals

  method vexpr expression =
    begin
      match expression with
      | Lval lval ->
	  ignore (Pretty.eprintf "lval of interest: %a\n" d_lval lval);
	  lvals := (Dissect.dissect lval (typeOfLval lval)) @ !lvals
      |	_ -> ()
    end;
    DoChildren
end


let collect instruction =
  let visitor = new visitor in
  ignore (visitCilInstr (visitor :> cilVisitor) instruction);
  visitor#result
