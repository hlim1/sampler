open Cil


let patch clones weights =

  let choice weight jump =
    match jump.skind with
    | Goto (dest, location) ->
	let dest' = clones#find !dest in
	If (integer weight,
	    mkBlock [mkStmt jump.skind],
	    mkBlock [mkStmt (Goto (ref dest', location))],
	    location)
    | _ ->
	failwith "unexpected statement kind in backward jumps list"
  in

  let patchOne choice jump =
	jump.skind <- choice
  in
  
  let patchBoth jump =
    let weight = weights#find jump in
    Printf.eprintf "CFG #%i has weight %i\n" jump.sid weight;
    let choice = choice weight jump in
    patchOne choice jump;
    patchOne choice (clones#find jump)
  in

  List.iter patchBoth
