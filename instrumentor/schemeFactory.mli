type t = Cil.file -> Scheme.c

val build : flag:string -> ident:string -> t -> t
