open Cil


let computation = BinOp (MinusA,
			 Lval Countdown.lval,
			 kinteger IUInt 1,
			 uintType)


let skipCall location =
  Set (Countdown.lval, computation, location)
	
	
class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set ((Mem _, NoOffset), _, location) ->
	ChangeTo [skipCall location; inst]
    | _ ->
	SkipChildren
end


let visit func =
  ignore (visitCilFunction new visitor func)
