open Cil

let check = Check.checkFile []

let process filename =
  let file = Frontc.parse filename () in
  Scanners.iterFuncs file (fun (func, _) -> DeadCode.visit func);
  dumpFile defaultCilPrinter stdout file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
