open Cil
open Printf


type phase = file -> unit


let doChecks = false

let check file =
  if doChecks then
    if not (Check.checkFile [] file) then
      raise Errormsg.Error


let doOneOne file action =
  action file;
  if ! Errormsg.hadErrors then
    raise Errormsg.Error;
  check file


let doOne stages filename =
  let file = Frontc.parse filename () in
  check file;
  List.iter (doOneOne file) stages
