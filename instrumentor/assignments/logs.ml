open Cil
open Pretty


let build logger lval where =
  let outputs = Dissect.dissect lval (typeOfLval lval) in
  let formats, arguments = List.split (OutputSet.OutputSet.elements outputs) in
  let format = ("%s:%u:\n\t" ^ String.concat "" formats ^ "\n") in

  Call (None, logger,
	mkString format
	:: mkString where.file
	:: kinteger IUInt where.line
	:: arguments,
	where)
