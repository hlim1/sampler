open Cil


class visitor func =
  object
    inherit FunctionBodyVisitor.visitor

    method vstmt _ = DoChildren

    method vinst = function
      | Call (None, callee, args, location) ->
	  begin
	    let resultType, _, _, _ = splitFunctionType (typeOf callee) in
	    match unrollType resultType with
	    | TInt _
	    | TEnum _
	    | TPtr _ ->
		let resultVar = makeTempVar func resultType in
		let result = Some (var resultVar) in
		ChangeTo [Call (result, callee, args, location)]
	    | _ ->
		SkipChildren
	  end
      | _ ->
	  SkipChildren
  end


let visit func =
  let visitor = new visitor func in
  ignore (visitCilFunction visitor func)
