open Types


val p : char Stream.t -> func

val entry : func -> node

val collectAll : symtab -> func -> symtab
val collectExports : symtab -> func -> symtab

val fixCallees : environment -> func -> unit
