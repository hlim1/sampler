open Cil
open OutputSet
open Str


let build logger func where =

  let isTemporary {vname = vname} =
    let pattern = regexp "^__\|^tmp$\|^tmp___[0-9]+$" in
    string_match pattern vname 0
  in

  let dissectVar varinfo =
    Dissect.dissect (var varinfo) varinfo.vtype
  in
  
  let rec dissectVars = function
    | [] ->
	OutputSet.empty
    | varinfo :: varinfos ->
	let remainder = dissectVars varinfos in
	if isTemporary varinfo then
	  remainder
	else
	  OutputSet.union remainder (dissectVar varinfo)
  in


  let formals = dissectVars func.sformals in
  let locals = dissectVars func.slocals in
  let outputs = OutputSet.union formals locals in
  let formats, arguments = List.split (OutputSet.elements outputs) in
  let format = mkString ("%s:%u:\n\t" ^ String.concat "\n\t" formats ^ "\n") in
  
  Call (None, logger,
	format
	:: mkString where.file
	:: kinteger IUInt where.line
	:: arguments,
	where)
