open Cil
open Pretty

let instr_where = function
  | Set(_, _, location) -> location
  | Call(_, _, _, location) -> location
  | Asm(_, _, _, _, _, location) -> location

let instr_what = function
  | Set(_, _, location) -> "Set"
  | Call(_, _, _, location) -> "Call"
  | Asm(_, _, _, _, _, location) -> "Asm"

let rec stmt_where = function
  | Instr([]) -> locUnknown
  | Instr(head::_) -> instr_where head
  | Return(_, location) -> location
  | Goto(_, location) -> location
  | Break(location) -> location
  | Continue(location) -> location
  | If(_, _, _, location) -> location
  | Switch(_, _, _, location) -> location
  | Loop(_, location) -> location
  | Block({bstmts = []}) -> locUnknown
  | Block({bstmts = {skind = skind} :: _}) -> stmt_where skind

let stmt_what = function
  | Instr(instrs) -> Printf.sprintf "Instr × %i" (List.length instrs)
  | Return(_) -> "Return"
  | Goto(_) -> "Goto"
  | Break(_) -> "Break"
  | Continue(_) -> "Continue"
  | If(_) -> "If"
  | Switch(_) -> "Switch"
  | Loop(_) -> "Loop"
  | Block({bstmts = bstmts}) -> Printf.sprintf "Block × %i" (List.length bstmts)

let stmt_describe stmt =
  let where = stmt_where stmt in
  Printf.sprintf "%s:%i: %s" where.file where.line (stmt_what stmt)
    
let d_stmt _ stmt =
  dprintf "%a: CFG #%i: %s" d_loc (stmt_where stmt.skind) stmt.sid (stmt_what stmt.skind)
    
let d_stmts _ stmts =
  seq line (d_stmt ()) stmts
    
let print_stmts stmts =
  fprint stdout 80 (d_stmts () stmts)
    
let warn stmt message =
  ignore(fprintf stderr "%a: %s\n" d_stmt stmt message)
