open Cil
open Printf

  
type phase = string * (file -> unit)

      
let doChecks = false

let check file = if doChecks then
  (if not (Check.checkFile [] file) then raise Errormsg.Error)
else
  ignore file

    
let doOneOne file (title, action) =
  eprintf "phase %s...\n" title;
  action file;
  if ! Errormsg.hadErrors then
    raise Errormsg.Error;
  eprintf "phase %s...check\n" title;
  check file;
  eprintf "phase %s...done\n" title
      
let doOne stages filename =
  eprintf "%s:\n" filename;
  let file = Frontc.parse filename () in
  (* Rmtmps.removeUnusedTemps file; *)
  check file;
  List.iter (doOneOne file) stages
    
let main stages =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter (doOne stages) filenames
