open Types


val p : char Stream.t -> compilation


val collectExports : symtab -> compilation -> symtab
val resolve : symtab -> compilation -> unit
