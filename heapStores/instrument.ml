open Cil


let makeLval = function
  | Lval lval -> lval
  | _ -> failwith "weird expression"
	
	
class visitor = object (self)
  inherit FunctionBodyVisitor.visitor
      
  method vstmt _ = DoChildren

  method vinst inst =
    begin
      match inst with
      | Set((Mem addr, NoOffset), data, location) as original ->
	  self#queueInstr
	    [Call (None, Lval (var LogWrite.logWrite),
		   [mkCast (mkString location.file) charConstPtrType;
		    kinteger IUInt location.line;
		    mkCast addr LogWrite.voidConstPtrType;
		    SizeOf(typeOf data);
		    mkCast (mkAddrOf (makeLval data)) LogWrite.voidConstPtrType],
		   location)]
      | _ -> ()
    end;
    SkipChildren
end


let visit original =
  let replacement = visitCilBlock (new visitor) original in
  assert (replacement == original)


let phase =
  "Instrument",
  visitCilFileSameGlobals new visitor
