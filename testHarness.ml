open Cil

let check = Check.checkFile []
    
let doOne stages filename =
  Printf.printf "%s:\n" filename;
  let file = Frontc.parse filename () in
  (* Rmtmps.removeUnusedTemps file; *)
  check file;
  List.iter (fun stage -> stage file; check file) stages
    
let main stages =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter (doOne stages) filenames
