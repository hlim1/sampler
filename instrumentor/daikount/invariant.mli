open Cil


type operand = {
    exp : exp;
    name : string;
  }


val invariant : file -> fundec -> location -> operand -> operand -> stmtkind * global

val register : file -> unit
