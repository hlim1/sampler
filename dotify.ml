open Cil
open Utils

let d_node _ stmt =
  Pretty.dprintf "n%i [label=\"CFG #%i%cn%a%cn%s\"];@!"
    stmt.sid
    stmt.sid '\\'
    d_loc (stmt_where stmt.skind) '\\'
    (stmt_what stmt.skind)

let d_edge _ source destination =
  Pretty.dprintf "n%i -> n%i;@!"
    source.sid
    destination.sid
