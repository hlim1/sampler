open Cil
open Pretty


class visitor logger (sites : FindSites.map) = object (self)
  inherit FunctionBodyVisitor.visitor

  method vstmt statement =
    if statement.sid == -1 then
      DoChildren
    else
      try
	let outputs = sites#find statement in
	let formats, arguments = List.split (OutputSet.OutputSet.elements outputs) in
	let format = ("%s:%u:\n" ^ String.concat "" formats) in
	let location = get_stmtLoc statement.skind in
	let call =
	  Call (None, logger,
		mkString format
		:: mkString location.file
		:: kinteger IUInt location.line
		:: arguments,
		location)
	in
	let block = Block (mkBlock [mkStmtOneInstr call; mkStmt statement.skind]) in
	let replace stmt =
	  stmt.skind <- block;
	  stmt
	in
	ChangeDoChildrenPost (statement, replace)
	  
      with Not_found -> DoChildren
end
