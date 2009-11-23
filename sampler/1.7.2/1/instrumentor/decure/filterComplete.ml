open Cil
open Rmtmps


let error = ref false


let main () =
  initCIL ();
  let filterFile filename =
    try
      let file = Frontc.parse filename () in
      removeUnusedTemps ~isRoot:isCompleteProgramRoot file;
      dumpFile defaultCilPrinter stdout file
    with Frontc.ParseError _ ->
      error := true
  in
  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter filterFile filenames;
  if !error then exit 1

;;

main ()
