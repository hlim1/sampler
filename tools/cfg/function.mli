open Types.Function


type result = key * data


val parse : Types.Compilation.key -> Symtab.t -> char Stream.t -> result

val addNodes : result -> unit
val addEdges : Symtab.t -> result -> unit
