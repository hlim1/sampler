open Cil
open OutputSet
open Str


let collect func =

  let outputs = new OutputSet.container in

  let isTemporary {vname = vname} =
    let pattern = regexp "^__\\|^tmp$\\|^tmp___[0-9]+$" in
    string_match pattern vname 0
  in

  let dissectVar varinfo =
    if not (isTemporary varinfo) then
      Dissect.dissect (var varinfo) varinfo.vtype outputs
  in
  
  let dissectVars = List.iter dissectVar in
  dissectVars func.sformals;
  dissectVars func.slocals;

  outputs
