open Cil
open ClonesMap


let patch clones weights countdown =
  
  let patchOne jump =
    let weight = weights#find jump in
    if weight != 0 then
      match jump.skind with
      | Goto (destination, location) ->

	  let clonedDest = findCloneOf clones !destination in
	  let gotoStandard = mkBlock [mkStmt jump.skind] in
	  let gotoInstrumented = mkBlock [mkStmt (Goto (ref clonedDest, location))] in
	  
	  let choice = countdown#choose location weight gotoInstrumented gotoStandard in
	  
	  jump.skind <- choice;
	  (findCloneOf clones jump).skind <- choice;
	  
      | _ -> failwith "unexpected statement kind in backward jumps list"
  in
  
  List.iter patchOne
