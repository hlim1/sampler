open Cil
    

class countdown : file -> fundec -> object
  method decrement : location -> stmtkind
  method export : instr
  method import : instr
  method checkThreshold : location -> int -> stmt -> stmt -> stmtkind
  method decrementAndCheckZero : stmtkind -> stmtkind
end
