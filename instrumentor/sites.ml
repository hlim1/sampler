open Cil


let patch clones countdown original =
  let original = original#embodiment in
  let location = get_stmtLoc original.skind in
  let decrement = countdown#decrement location in
  let clone = ClonesMap.findCloneOf clones original in
  original.skind <- decrement;
  clone.skind <- countdown#decrementAndCheckZero clone.skind
