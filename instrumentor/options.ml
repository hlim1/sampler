open Cil
open Arg


type argspec = string * spec * string


let args = ref []


let push argspec =
  args := argspec :: !args


let registerBoolean ~flag ~desc ~ident value =
  push ("--no-" ^ flag, Clear value, "");
  push ("--" ^ flag, Set value, desc);
  Idents.register (ident, fun () -> string_of_bool !value)


let argspecs () = !args
