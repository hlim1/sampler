open Cil


let prepatch weights =
  let patchOne jump =
    match jump.skind with
    | Goto (destination, location) ->
	let patchSite = ref !destination in
	let gotoStandard = mkBlock [mkStmt jump.skind] in
	let gotoInstrumented = mkBlock [mkStmt (Goto (patchSite, location))] in
	let weight = weights#find jump in
	let choice = LogIsImminent.choose location weight gotoInstrumented gotoStandard in
	jump.skind <- choice;
	patchSite
    | _ -> failwith "unexpected statement kind in backward jumps list"
  in
  List.map patchOne


let patch clones =
  let patchOne dest = dest := clones#find !dest in
  List.iter patchOne
