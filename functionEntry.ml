open Cil


let find func =
  match func.sbody.bstmts with
  | {sid = 0} as root :: _ -> root
  | _ -> ignore (bug "cannot find function entry"); dummyStmt


let patch func weights countdown instrumented =
  let entry = find func in
  let import = mkStmtOneInstr (countdown#afterCall locUnknown) in
  let weight = weights#find entry in

  let body =
    let original = func.sbody in
    if weight == 0 then
      let finis = mkEmptyStmt () in
      finis.labels <- [ Label ("finis", locUnknown, false) ];
      [ import;
	mkStmt (Block original);
	mkStmt (Goto (ref finis, locUnknown));
	mkStmt (Block instrumented);
	finis ]
    else
      let choice = countdown#choose locUnknown weight instrumented original in
      [ import;
	mkStmt choice ]
  in
  
  func.sbody <- mkBlock body
