type result = Compilation.result list


val parse : string -> char Stream.t -> result

val addNodes : result -> unit
val addEdges : result -> unit
