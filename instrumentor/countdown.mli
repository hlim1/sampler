open Cil
    

type token

val find : file -> token

class countdown : token -> fundec -> object
  method decrement : location -> stmtkind
  method export : instr
  method import : instr
  method checkThreshold : location -> int -> stmt -> stmt -> stmtkind
  method decrementAndCheckZero : stmtkind -> stmtkind
end
