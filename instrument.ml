open Cil


let logWrite =
  let f = emptyFunction "logWrite" in
  let arg name typ = ignore (makeFormalVar f ~where:"$" name typ) in
  arg "file" charConstPtrType;
  arg "line" uintType;
  arg "address" voidPtrType;
  arg "size" uintType;
  arg "data" voidPtrType;
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
			[mkString !currentLoc.file;
			 kinteger IUInt !currentLoc.line;
			 mkCast addr voidPtrType;
			 SizeOf(typeOf data);
			 mkCast (mkAddrOf (makeLval !currentFunction data)) voidPtrType],
			location);
		  original]
    | _ -> SkipChildren
end


let phase _ =
  ("Instrument", fun file ->
    addPrototype file;
    visitCilFileSameGlobals new visitor file)
