open Cil
open Printf


type phase = string * (file -> unit)


let doChecks = false

let check file title =
  if doChecks then
    begin
      if not (Check.checkFile [] file) then
	raise Errormsg.Error
    end
  else
    ignore file

    
let doOneOne file (title, action) =
  action file;
  if ! Errormsg.hadErrors then
    raise Errormsg.Error;
  check file title
      
let doOne stages filename =
  let file = Frontc.parse filename () in
  check file "parse";
  List.iter (doOneOne file) stages
    
let main stages =
  initCIL ();
  printLnComment := true;

  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter (doOne stages) filenames
