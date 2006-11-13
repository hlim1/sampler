open Cil

let check = Check.checkFile []

let process filename =
  let file = Frontc.parse filename () in
  let examineGlobal = function
    | GFun (func, _) -> DeadCode.visit func
    | _ -> ()
  in
  iterGlobals file examineGlobal;
  dumpFile defaultCilPrinter stdout file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
