open Cil
open Rmtmps


let main () =
  initCIL ();
  let filterFile filename =
    let file = Frontc.parse filename () in
    removeUnusedTemps ~markRoots:markCompleteProgramRoots file;
    dumpFile defaultCilPrinter stdout file
  in
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter filterFile filenames

;;

main ()
