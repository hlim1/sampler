val argspecs : unit -> (string * Arg.spec * string) list

val registerBoolean : flag:string -> desc:string -> ident:string -> bool ref -> unit
val registerString  : flag:string -> desc:string -> ident:string -> string ref -> unit

val phase : TestHarness.phase
