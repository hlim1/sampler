open Cil
open Printf


let logWrite =
  let f = emptyFunction "logWrite" in
  let arg = makeFormalVar f ~where:"$" in
  let a = arg "address" voidPtrType in
  let s = arg "size" uintType in
  let d = arg "data" voidPtrType in
  f.svar
    

let addPrototype file =
  file.globals <- GVarDecl (logWrite, logWrite.vdecl) :: file.globals


let makeLval fundec = function
  | Lval lval -> lval
  | Const _ as const ->
      let temp = makeTempVar fundec ~name:"const" (typeOf const) in
      var temp
  | _ -> failwith "weird expression"
	

class visitor = object
  inherit CurrentFunctionVisitor.visitor

  method vinst = function
    | Set((Mem addr, _), data, location) as original ->
	ChangeTo [Call (None, Lval (var logWrite),
			[mkCast addr voidPtrType;
			 SizeOf(typeOf data);
			 mkCast (mkAddrOf (makeLval !currentFunction data)) voidPtrType],
			location);
		  original]
    | _ -> SkipChildren
end
