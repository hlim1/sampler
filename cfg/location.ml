open Basics


type t = { file : string; line : int }


let p =
  let filename = wordTab in
  let lineno = integerLine in
  parser
      [< file = filename; line = lineno >] ->
	{ file = file; line = line }
