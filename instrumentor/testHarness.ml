open Cil
open Printf


let showPhaseTimes =
  Options.registerBoolean
    ~flag:"show-phase-times"
    ~desc:"print the length of time taken to complete each phase"
    ~ident:""
    ~default:false


type phase = string * (file -> unit)


let depth = ref 0

let time =
  fun description action ->
    if !showPhaseTimes then
      begin
	let indent = String.make (2 * !depth) ' ' in
	Printf.eprintf "%s%s: begin\n" indent description;
	incr depth;
	flush stderr;
	let before = Unix.gettimeofday () in
	let result = action () in
	let after = Unix.gettimeofday () in
	decr depth;
	Printf.eprintf "%s%s: end; %f sec\n" indent description (after -. before);
	flush stderr;
	result
      end
    else
      action ()

let doChecks = false

let check file =
  if doChecks then
    if not (Check.checkFile [] file) then
      raise Errormsg.Error


let doOneOne file (description, action) =
  time description (fun () -> action file);
  if ! Errormsg.hadErrors then
    raise Errormsg.Error;
  check file


let doOne phases filename =
  let thunk : unit -> file = time "parsing" (fun () -> Frontc.parse filename) in
  let file : file = time "converting to CIL" thunk in
  check file;
  List.iter (doOneOne file) phases
