module OutputSet = Set.Make(
  struct
    type t = Cil.lval
    let compare = compare
  end
 )
