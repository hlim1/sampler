open Cil
open Pretty


class visitor logger (sites : FindSites.map) = object (self)
    inherit FunctionBodyVisitor.visitor

    method vstmt statement =
      begin
	try
	  let outputs = sites#find statement in
	  let formats, arguments = List.split (OutputSet.OutputSet.elements outputs) in
	  let format = ("%s:%u:\n" ^ String.concat "" formats) in
	  let location = Where.statement statement in
	  let call =
	    Call (None, logger,
		  mkString format
		  :: mkString location.file
		  :: kinteger IUInt location.line
		  :: arguments,
		  location)
	  in
	  self#queueInstr [call]
	with Not_found -> ()
      end;
      DoChildren
  end
