open Cil


let find func =
  match func.sbody.bstmts with
  | {sid = 0} as root :: _ -> root
  | _ -> ignore (bug "cannot find function entry"); dummyStmt


let patch func weights instrumented =
  let entry = find func in
  let weight = weights#find entry in
  let choice = LogIsImminent.choose locUnknown weight instrumented func.sbody in
  func.sbody <- mkBlock [mkStmt choice]
