open Cil


let patch clones =

  let patchOne jump =
    match jump.skind with
    | Goto (dest, location) ->
	let dest' = clones#find !dest in
	let choice = If (zero,
			 mkBlock [mkStmt jump.skind],
			 mkBlock [mkStmt (Goto (ref dest', location))],
			 location) in
	jump.skind <- choice
    | _ ->
	failwith "unexpected statement kind in backward jumps list"
  in
  
  let patchBoth jump =
    patchOne jump;
    patchOne (clones#find jump)
  in

  List.iter patchBoth
