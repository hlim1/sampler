open Cil


let patch clones =

  let patchOne jump =
    match jump.skind with
    | Goto (dest, location) ->
	let dest' = clones#find !dest in
	jump.skind <- Goto (ref dest', location)
    | _ ->
	failwith "unexpected statement kind in forward jumps list"
  in
  
  let patchClone jump =
    patchOne (clones#find jump)
  in

  List.iter patchClone
