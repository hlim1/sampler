open Cil


let patch clones weights countdown =
  
  let patchOne jump =
    let weight = weights#find jump in
    if weight != 0 then
      match jump.skind with
      | Goto (destination, location) ->

	  let clonedDest = clones#find !destination in
	  let gotoStandard = mkBlock [mkStmt jump.skind] in
	  let gotoInstrumented = mkBlock [mkStmt (Goto (ref clonedDest, location))] in
	  
	  let choice = LogIsImminent.choose location weight countdown gotoInstrumented gotoStandard in
	  
	  jump.skind <- choice;
	  (clones#find jump).skind <- choice;
	  
      | _ -> failwith "unexpected statement kind in backward jumps list"
  in
  
  List.iter patchOne
