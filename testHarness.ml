open Cil

let visitOneOne file visitor =
  visitCilFileSameGlobals visitor file

let visitOne visitors arg =
  Printf.printf "%s:\n" arg;
  let file = Frontc.parse arg () in
  (* Rmtmps.removeUnusedTemps file; *)
  List.iter (visitOneOne file) visitors;
  file
    
let main visitors =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.map (visitOne visitors) filenames
