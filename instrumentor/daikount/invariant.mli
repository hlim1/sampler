open Cil


type operand = {
    exp : exp;
    name : string;
  }


val invariant : file -> fundec -> location -> operand -> operand -> Site.t

val register : file -> unit
