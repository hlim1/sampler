open Cil
open OutputSet
open Str


let collect func =

  let isTemporary {vname = vname} =
    let pattern = regexp "^__\\|^tmp$\\|^tmp___[0-9]+$" in
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
  OutputSet.union formals locals
