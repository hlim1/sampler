open Cil

let visitOne visitors arg =
  let file = Frontc.parse arg () in
  Rmtmps.removeUnusedTemps file;
  
  List.iter (fun visitor -> visitCilFileSameGlobals (visitor :> cilVisitor) file) visitors;
  file
    
let main visitors =
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.map (visitOne visitors) filenames
