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
    begin
      Printf.eprintf "%s: begin\n%!" description;
      let before = Unix.gettimeofday () in
      let result = action () in
      let after = Unix.gettimeofday () in
      Printf.eprintf "%s: end; %f sec\n%!" description (after -. before);
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
  let thunk = time "parsing" (fun () -> Frontc.parse filename) in
  let file = time "converting to CIL" thunk in
  check file;
  List.iter (doOneOne file) phases
