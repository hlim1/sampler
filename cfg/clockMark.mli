type t

val mark : unit -> t
val unmark : unit -> t

val marked : t -> bool
val reset : unit -> unit
