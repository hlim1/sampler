open Cil
open Printf


let showPhaseTimes =
  Options.registerBoolean
    ~flag:"show-phase-times"
    ~desc:"print the length of time taken to complete each phase"
    ~ident:""
    ~default:false


type phase = string * (file -> unit)


let time description action =
  if !showPhaseTimes then
    let before = Unix.gettimeofday () in
    let result = action () in
    let after = Unix.gettimeofday () in
    Printf.eprintf "%s: %f sec\n" description (after -. before);
    result
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
  let file = time "parsing" (Frontc.parse filename) in
  check file;
  List.iter (doOneOne file) phases
