type argspec = string * Arg.spec * string


val push : argspec -> unit

val argspecs : unit -> argspec list


val registerBoolean : flag:string -> desc:string -> ident:string -> bool ref -> unit
