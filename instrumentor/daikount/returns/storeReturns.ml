open Cil


class visitor func =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt _ = DoChildren

    method vinst = function
      | Call (None, callee, args, location) ->
	  begin
	    match splitFunctionType (typeOf callee) with
	    | TVoid _, _, _, _ ->
		SkipChildren
	    | resultType, _, _, _ ->
		let resultVar = makeTempVar func resultType in
		let result = Some (var resultVar) in
		ChangeTo [Call (result, callee, args, location)]
	  end
      | _ ->
	  SkipChildren
  end


let visit func =
  let visitor = new visitor func in
  ignore (visitCilFunction visitor func)
