open Cil


type idomMap


class dominatorTree : idomMap -> object
  method idom : stmt -> stmt option
  method dominates : stmt -> stmt -> bool
  method strictlyDominates : stmt -> stmt -> bool
end


val computeDominators : stmt * stmt list -> dominatorTree
