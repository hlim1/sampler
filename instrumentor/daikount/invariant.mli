open Cil


type operand = {
    exp : exp;
    name : string;
  }


val invariant : file -> fundec -> location -> operand -> operand -> global * stmt

val register : file -> unit
