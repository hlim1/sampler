open Types


val p : char Stream.t -> func


val collectAll : symtab -> func -> symtab
val collectExports : symtab -> func -> symtab
val resolve : environment -> func -> unit
