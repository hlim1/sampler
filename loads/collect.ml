open Cil
open OutputSet


class visitor = object
  inherit nopCilVisitor

  val mutable outputs = OutputSet.empty
  method result = outputs

  method vexpr expression =
    begin
      match expression with
      | Lval lval ->
	  let dissection = Dissect.dissect lval (typeOfLval lval) in
	  outputs <- OutputSet.union outputs dissection
      |	_ -> ()
    end;
    DoChildren
end


let collect visit root =
  let visitor = new visitor in
  ignore (visit (visitor :> cilVisitor) root);
  visitor#result


let collectExpr = collect visitCilExpr

let collectInstr = collect visitCilInstr
