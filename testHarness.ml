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

    
let verbose = false

let verbosely title action =
  let print event =
    if verbose then
      prerr_endline (title ^ ": " ^ event)
  in
  
  print "begin";
  let result = action () in
  print "end";
  result

let doOneOne file (title, action) =
  verbosely title
  (fun _ ->
    action file;
    if ! Errormsg.hadErrors then
      raise Errormsg.Error;
    check file title)

let doOne stages filename =
  let file = verbosely "parse"
      (fun _ ->
	let file = Frontc.parse filename () in
	check file "parse";
	file)
  in
  List.iter (doOneOne file) stages
    
let main stages =
  initCIL ();
  (* printLnComment := true; *)

  let filenames = List.tl (Array.to_list Sys.argv) in
  List.iter (doOne stages) filenames
