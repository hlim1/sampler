open Cil


let patch clones =
  let patchOne jump =
    match jump.skind with
    | Goto (destination, location) ->
	let clonedJump = clones#find jump in
	let clonedDest = clones#find !destination in
	clonedJump.skind <- Goto (ref clonedDest, location)
    | _ ->
	failwith "unexpected statement kind in forward jumps list"
  in
  List.iter patchOne
