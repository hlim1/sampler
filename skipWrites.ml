open Cil


let skipCall location =
  Set (Countdown.lval,
       BinOp (MinusA,
	      Lval Countdown.lval,
	      one,
	      uintType),
       location)
	
	
class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set ((Mem _, _), _, location) ->
	ChangeTo [skipCall location; inst]
    | _ ->
	SkipChildren
end


let visit func =
  ignore (visitCilFunction new visitor func)
