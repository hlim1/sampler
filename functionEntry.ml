open Cil


let find func =
  match func.sbody.bstmts with
  | {sid = 0} as root :: _ -> root
  | _ -> ignore (bug "cannot find function entry"); dummyStmt


let patch func weights countdown instrumented =
  let entry = find func in
  let weight = weights#find entry in

  let body =
    if weight == 0 then
      let finis = mkEmptyStmt () in
      finis.labels <- [ Label ("finis", locUnknown, false) ];
      [ mkStmt (Block func.sbody);
	mkStmt (Goto (ref finis, locUnknown));
	mkStmt (Block instrumented);
	finis ]
    else
      let choice = LogIsImminent.choose locUnknown weight countdown instrumented func.sbody in
      [ mkStmt choice ]
  in
  
  func.sbody <- mkBlock body
