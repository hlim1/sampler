open Cil


let insert clones sites =

  let insertOne original ((address, data, location) : (exp * lval * location)) =
    let instrumented = ClonesMap.findCloneOf clones original in
    let call = Call (None, Lval (var LogWrite.logWrite),
		     [mkCast (mkString location.file) charConstPtrType;
		      kinteger IUInt location.line;
		      mkCast address LogWrite.voidConstPtrType;
		      SizeOf(typeOfLval data);
		      mkCast (mkAddrOf data) LogWrite.voidConstPtrType],
		     location)
    in
    let block = Block (mkBlock [mkStmtOneInstr call;
				mkStmt instrumented.skind]) in
    instrumented.skind <- block
  in

  sites#iter insertOne
