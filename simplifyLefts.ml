open Cil


let returnTypeOf typ =
  let (return, _, _, _) = splitFunctionType typ in
  return



class visitor = object
  inherit CurrentFunctionVisitor.visitor

  method vinst = function
    | Set ((Mem(expr), offset) as lval, data, location) ->
	begin
	  match (expr, offset) with
	  | (Lval (Var _, NoOffset), NoOffset) ->
	      SkipChildren
	  | _ ->
	      let addr = mkAddrOf lval in
	      let temp = var (makeTempVar !currentFunction ~name:"left" (typeOf addr)) in
	      let mem = mkMem (Lval temp) NoOffset in
	      ChangeTo [Set (temp, addr, location);
			Set (mem, data, location)]
	end
    | _ -> SkipChildren
end
