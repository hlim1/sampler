open Cil
open Pretty

let instr_what = function
  | Set(_, _, location) -> "Set"
  | Call(_, _, _, location) -> "Call"
  | Asm(_, _, _, _, _, location) -> "Asm"

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
  | TryFinally(_) -> "TryFinally"
  | TryExcept(_) -> "TryExcept"

let stmt_describe stmt =
  let where = get_stmtLoc stmt in
  Printf.sprintf "%s:%i: %s" where.file where.line (stmt_what stmt)
    
let d_stmt _ stmt =
  dprintf "%a: CFG #%i: %s" d_loc (get_stmtLoc stmt.skind) stmt.sid (stmt_what stmt.skind)
    
let d_stmts _ stmts =
  seq line (d_stmt ()) stmts
    
let print_stmts stmts =
  fprint stdout 80 (d_stmts () stmts)
    
let warn stmt message =
  ignore(fprintf stderr "%a: %s\n" d_stmt stmt message)


let d_labels () {labels = labels} =

  let rec labelNames = function
  | [] -> []
  | Label (name, _, _) :: rest ->
      name :: labelNames rest
  | _ :: rest ->
      labelNames rest
  in

  chr '['
    ++ (seq
	  ~sep:(text "; ")
	  ~doit:text
	  ~elements:(labelNames labels))
    ++ chr ']'


let d_preds () {preds = preds} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:preds


let d_succs () {succs = succs} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:succs
