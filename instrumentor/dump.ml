open Cil

let check = Check.checkFile []

let process filename =
  let s = mkString "foo" in
  ignore (Pretty.eprintf "literal string has type %a@!" d_type (typeOf s));
  ignore (Pretty.eprintf "fixed export is type %a@!" d_type charConstPtrType);
  let file = Frontc.parse filename () in
  Rmtmps.removeUnusedTemps file;
  dumpFile defaultCilPrinter stdout file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
