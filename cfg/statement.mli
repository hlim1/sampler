type result = Types.Statement.data


val parse : char Stream.t -> result

val isReturn : result -> bool

val addNodes : Types.Statement.key -> result -> unit
val addEdges : Symtab.t -> Types.Statement.key -> result -> unit
