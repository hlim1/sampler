open Cil


let instruction = function
  | Set (_, _, location)
  | Call (_, _, _, location)
  | Asm (_, _, _, _, _, location) ->
      location


let rec statement {skind = skind} =
  match skind with
  | Instr [] ->
      locUnknown
  | Instr instrs ->
      instruction (List.hd instrs)
	
  | Return (_, location)
  | Goto (_, location)
  | Break location
  | Continue location
  | If (_, _, _, location)
  | Switch (_, _, _, location)
  | Loop (_, location, _, _) ->
      location

  | Block {bstmts = []} ->
      locUnknown
  | Block {bstmts = bstmts} ->
      statement (List.hd bstmts)
