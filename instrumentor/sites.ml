open Cil


type info = Site.t list


let patch clones countdown original =
  let location = get_stmtLoc original.skind in
  let decrement = countdown#decrement location in
  let clone = ClonesMap.findCloneOf clones original in
  original.skind <- decrement;
  clone.skind <- countdown#decrementAndCheckZero clone.skind
