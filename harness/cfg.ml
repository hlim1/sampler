open Cil
  

type cfg = stmt * stmt list

let cfg func =
  prepareCFG func;
  let stmts = computeCFGInfo func false in
  let root = List.hd func.sbody.bstmts in

  if root.sid != 0 then
    ignore(bug "first statement in function body is not root of CFG");

  (root, stmts)
