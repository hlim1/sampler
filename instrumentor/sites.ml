open Cil
open Scanf
open Scanning
open Site


let registry = new FunctionNameHash.c 1


let loadScales =
  Options.registerString
    ~flag:"load-scales"
    ~desc:"load non-default site scaling factors from the named file"
    ~ident:"LoadScales"


let setScales () =
  if !loadScales <> "" then
    let index = new StringIntHash.c 1 in
    registry#iter
      (fun func site -> index#add (func.svar.vname, site.statement.sid) site);

    let scanbuf = from_file !loadScales in
    while not (end_of_input scanbuf) do
      let process func id scale =
	Printf.eprintf "set scale: %s() id %d <-- %d\n" func id scale;
	let site = index#find (func, id) in
	site.scale <- scale
      in
      bscanf scanbuf "%s@\t%d\t%d\n" process
    done;
    registry#iter
      (fun func site ->
	Printf.eprintf "site registry: %s() id %d\n" func.svar.vname site.statement.sid)


let patch clones countdown site =
  let original = site.statement in
  let scale = site.scale in
  let location = get_stmtLoc original.skind in
  let decrement = countdown#decrement location scale in
  let clone = ClonesMap.findCloneOf clones original in
  original.skind <- decrement;
  clone.skind <- countdown#decrementAndCheckZero clone.skind scale
