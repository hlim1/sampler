open Types


val p : char Stream.t -> compilation


val collectExports : symtab -> compilation -> symtab
val fixCallees : symtab -> compilation -> unit
