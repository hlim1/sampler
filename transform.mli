open Cil


val transform : (stmt -> int) -> (block -> unit) -> (block -> unit) -> fundec -> unit
