module OutputSet = Set.Make(
  struct
    type t = string * Cil.exp
    let compare (format, _) (format', _) = compare format format'
  end
 )
