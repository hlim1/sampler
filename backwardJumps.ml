open Cil


let patch clones weights func =

  let choice weight jump =
    match jump.skind with
    | Goto (dest, location) ->
	let imminent = makeTempVar func ~name:"imminent" intType in
	let lval = (Var imminent, NoOffset) in
	let call = Call (Some lval, Lval (var LogIsImminent.logIsImminent), [kinteger IUInt weight], location) in
	let branch =
	  let dest' = clones#find !dest in
	  If (Lval lval,
	      mkBlock [mkStmt (Goto (ref dest', location))],
	      mkBlock [mkStmt jump.skind],
	      location)
	in
	Block (mkBlock [mkStmtOneInstr call; mkStmt branch])
	
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
