open Cil


class visitor = object(self)
  inherit SimplifyVisitor.visitor

  method vinst instr =
    match instr with
    | Set ((Mem(expr), offset) as lval, data, location) when BitFields.absent offset ->
	begin
	  match (expr, offset) with
	  | (Lval (Var _, NoOffset), NoOffset) ->
	      SkipChildren
	  | _ ->
	      let addr = mkAddrOf lval in
	      let temp = var (self#makeTempVar "left" (typeOf addr)) in
	      let mem = mkMem (Lval temp) NoOffset in
	      ChangeTo [Set (temp, addr, location); Set (mem, data, location)]
	end
    | _ -> SkipChildren
end


let phase =
  "SimplifyLefts",
  visitCilFileSameGlobals new visitor
