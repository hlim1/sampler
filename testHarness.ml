open Cil

let doChecks = false

let check = if doChecks then
  Check.checkFile []
else
  ignore
    
let doOneOne file stage =
  stage file;
  if ! Errormsg.hadErrors then
    raise Errormsg.Error;
  check file
      
let doOne stages filename =
  Printf.printf "%s:\n" filename;
  let file = Frontc.parse filename () in
  (* Rmtmps.removeUnusedTemps file; *)
  check file;
  List.iter (doOneOne file) stages
    
let main stages =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter (doOne stages) filenames
