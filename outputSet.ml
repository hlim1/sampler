module OutputSet = Set.Make(
  struct
    type t = string * Cil.exp
    let compare = compare
  end
 )
