open Cil


class visitor fundec =
  object
    inherit nopCilVisitor

    val collection = new VarSet.container
    method result = collection

    method vexpr = function
      | SizeOfE _ -> SkipChildren
      | _ -> DoChildren

    method vvrbl varinfo =
      if varinfo.vstorage == Static && varinfo != fundec.svar then
	collection#add varinfo;
      SkipChildren
  end


let collect fundec =
  let visitor = new visitor fundec in
  ignore (visitCilFunction visitor fundec);
  visitor#result
