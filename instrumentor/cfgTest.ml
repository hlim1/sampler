open Cil

let process filename =
  let file = Frontc.parse filename () in
  EmbedCFG.visit file;
  dumpFile defaultCilPrinter stdout file

;;

initCIL ();
lineDirectiveStyle := None;

let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
