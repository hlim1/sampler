val argspecs : unit -> (string * Arg.spec * string) list

val registerBoolean : bool ref -> flag:string -> desc:string -> ident:string -> unit

val phase : TestHarness.phase
