open Cil

let check = Check.checkFile []
    
let process filename =
  Printf.printf "%s:\n" filename;
  let file = Frontc.parse filename () in
  Check.checkFile [] file
    
let main =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter process filenames
