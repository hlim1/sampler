open Cil


type token

val find : file -> token

class countdown : token -> fundec -> object
  method decrement : location -> instr
  method beforeCall : location -> instr
  method afterCall : location -> instr
  method choose : location -> int -> block -> block -> stmtkind
  method log : location -> instr list -> stmt list
end
