exception Empty


class ['element] c :
  object
    method isEmpty : bool
    method length : int

    method pushFront : 'element -> unit
    method pushBack  : 'element -> unit

    method popFront : 'element
    method popBack  : 'element

    method iterFromFront : ('element -> unit) -> unit
    method iterFromBack  : ('element -> unit) -> unit
(*
    method map : ('element -> 'transformed) -> 'transformed c
*)
    method foldFromFront : ('accumulator -> 'element -> 'accumulator) -> 'accumulator -> 'accumulator
    method foldFromBack  : ('accumulator -> 'element -> 'accumulator) -> 'accumulator -> 'accumulator
  end
