open Cil
open Pretty


let insert logger clones sites =

  let insertOne original outputs =
    let instrumented = ClonesMap.findCloneOf clones original in
    let formats, arguments = List.split (OutputSet.OutputSet.elements outputs) in
    let format = ("%s:%u:\n" ^ String.concat "" formats) in
    let location = get_stmtLoc instrumented.skind in
    let call =
      Call (None, logger,
	    mkString format
	    :: mkString location.file
	    :: kinteger IUInt location.line
	    :: arguments,
	    location)
    in
    let block = Block (mkBlock [mkStmtOneInstr call;
				mkStmt instrumented.skind]) in
    instrumented.skind <- block
  in

  sites#iter insertOne
