open Cil

type cfg = stmt * stmt list

let cfg func =
  prepareCFG func;
  (List.hd func.sbody.bstmts, computeCFGInfo func)
