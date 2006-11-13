open Cil
open Interesting


class visitor func =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt _ = DoChildren

    method vinst = function
      | Call (None, callee, args, location) ->
	  let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	  if isInterestingType resultType then
	    let resultVar = makeTempVar func resultType in
	    let result = Some (var resultVar) in
	    ChangeTo [Call (result, callee, args, location)]
	  else
	    SkipChildren
      | _ ->
	  SkipChildren
  end


let visit func =
  let visitor = new visitor func in
  ignore (visitCilFunction visitor func)
