open Cil


let makeLval = function
  | Lval lval -> lval
  | _ -> failwith "weird expression"
	
	
class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    match inst with
    | Set((Mem addr, _), data, location) as original ->
	Printf.eprintf "%s:%i: adding instrumentation point\n"
	  location.file location.line;
	ChangeTo [Call (None, Lval (var LogWrite.logWrite),
			[mkCast (mkString location.file) charConstPtrType;
			 kinteger IUInt location.line;
			 mkCast addr LogWrite.voidConstPtrType;
			 SizeOf(typeOf data);
			 mkCast (mkAddrOf (makeLval data)) voidPtrType],
			location);
		  original]
    | _ -> SkipChildren
end


let phase _ =
  ("Instrument", fun file ->
    LogWrite.addPrototype file;
    visitCilFileSameGlobals new visitor file)
