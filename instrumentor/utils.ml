open Cil
open Pretty

let instr_what = function
  | Set _ -> "Set"
  | Call _ -> "Call"
  | Asm _ -> "Asm"

let stmt_what = 
IFDEF HAVE_COMPUTED_GOTO THEN
  function
  | Instr instrs -> Printf.sprintf "Instr � %i" (List.length instrs)
  | Return _ -> "Return"
  | Goto _ -> "Goto"
  | ComputedGoto _ -> "ComputedGoto"
  | Break _ -> "Break"
  | Continue _ -> "Continue"
  | If _ -> "If"
  | Switch _ -> "Switch"
  | Loop _ -> "Loop"
  | Block {bstmts; _} -> Printf.sprintf "Block � %i" (List.length bstmts)
  | TryFinally _ -> "TryFinally"
  | TryExcept _ -> "TryExcept"
ELSE
  function
  | Instr instrs -> Printf.sprintf "Instr � %i" (List.length instrs)
  | Return _ -> "Return"
  | Goto _ -> "Goto"
  | Break _ -> "Break"
  | Continue _ -> "Continue"
  | If _ -> "If"
  | Switch _ -> "Switch"
  | Loop _ -> "Loop"
  | Block {bstmts; _} -> Printf.sprintf "Block � %i" (List.length bstmts)
  | TryFinally _ -> "TryFinally"
  | TryExcept _ -> "TryExcept"
ENDIF

let stmt_describe stmt =
  let where = get_stmtLoc stmt in
  Printf.sprintf "%s:%i: %s" where.file where.line (stmt_what stmt)
    
let d_stmt _ stmt =
  dprintf "%a: CFG #%i: %s" d_loc (get_stmtLoc stmt.skind) stmt.sid (stmt_what stmt.skind)
    
let d_stmts _ stmts =
  seq ~sep:line ~doit:(d_stmt ()) ~elements:stmts
    
let print_stmts stmts =
  fprint stdout ~width:80 (d_stmts () stmts)
    
let warn stmt message =
  ignore(fprintf stderr "%a: %s\n" d_stmt stmt message)


let d_label () = 
IFDEF HAVE_CASE_RANGE THEN
  function
  | Label (name, _, _) ->
      text name
  | Case (expr, _) ->
      text "case " ++ d_exp () expr
  | CaseRange (lower, upper, _) ->
      text "case " ++ d_exp () lower ++ text " ... " ++ d_exp () upper
  | Default _ ->
      text "default"
ELSE
  function
  | Label (name, _, _) ->
      text name
  | Case (expr, _) ->
      text "case " ++ d_exp () expr
  | Default _ ->
      text "default"
ENDIF

let d_labels () labels =
  seq
    ~sep:(text "; ")
    ~doit:(d_label ())
    ~elements:labels


let d_preds () {preds; _} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:preds


let d_succs () {succs; _} =
  seq
    ~sep:(text "; ")
    ~doit:(fun stmt -> num stmt.sid)
    ~elements:succs
