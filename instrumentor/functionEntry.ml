open Cil


let find func =
  match func.sbody.bstmts with
  | {sid = 0} as root :: _ -> root
  | _ -> ignore (bug "cannot find function entry"); dummyStmt


let patch func weights countdown instrumented =
  let entry = find func in
  let import = mkStmtOneInstr (countdown#import locUnknown) in

  let original = mkStmt (Block func.sbody) in
  let instrumented = mkStmt (Block instrumented) in
  original.labels <- Label ("original", locUnknown, false) :: original.labels;
  instrumented.labels <- Label ("instrumented", locUnknown, false) :: instrumented.labels;

  let weight = weights#find entry in
  let choice = countdown#checkThreshold locUnknown weight instrumented original in

  let finis = mkEmptyStmt () in
  finis.labels <- [ Label ("finis", locUnknown, false) ];

  func.sbody <- mkBlock [ import;
			  mkStmt choice;
			  original;
			  mkStmt (Goto (ref finis, locUnknown));
			  instrumented;
			  finis ]
