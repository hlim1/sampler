open Cil
open Pretty


let build logger outputs location =
  let formats, arguments = List.split (OutputSet.OutputSet.elements outputs) in
  let format = ("%s:%u:\n" ^ String.concat "" formats) in

  Call (None, logger,
	mkString format
	:: mkString location.file
	:: kinteger IUInt location.line
	:: arguments,
	location)
