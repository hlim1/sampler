open Cil
open ClonesMap


let patch clones =
  let patchOne jump =
    match jump.skind with
    | Goto (destination, location) ->
	let clonedJump = findCloneOf clones jump in
	let clonedDest = findCloneOf clones !destination in
	clonedJump.skind <- Goto (ref clonedDest, location)
    | _ ->
	failwith "unexpected statement kind in forward jumps list"
  in
  List.iter patchOne
