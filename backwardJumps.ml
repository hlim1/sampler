open Cil


let patch clones weights func =

  let choice weight jump =
    match jump.skind with
    | Goto (dest, location) ->
	let branch =
	  let dest' = clones#find !dest in
	  LogIsImminent.choose func location weight
	    (mkBlock [mkStmt jump.skind])
	    (mkBlock [mkStmt (Goto (ref dest', location))])
	in
	Block branch
	
    | _ ->
	failwith "unexpected statement kind in backward jumps list"
  in

  let patchOne choice jump =
	jump.skind <- choice
  in
  
  let patchBoth jump =
    let weight = weights#find jump in
    Printf.eprintf "patcher: CFG #%i has weight %i\n" jump.sid weight;
    if weight != 0 then
      begin
	let choice = choice weight jump in
	patchOne choice jump;
	patchOne choice (clones#find jump)
      end
  in

  List.iter patchBoth
