open Cil


type token

val find : file -> token

class countdown : token -> fundec -> object
  method decrement : location -> stmtkind
  method beforeCall : location -> instr
  method afterCall : location -> instr
  method checkThreshold : location -> int -> block -> block -> stmtkind
  method decrementAndCheckZero : stmtkind -> stmtkind
end
