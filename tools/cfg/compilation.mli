type result = Function.result list * Symtab.t


val parse : Types.Object.key -> char Stream.t -> result

val addNodes : result -> unit
val addEdges : result -> unit
