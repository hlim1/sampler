type result = Types.Statement.data


val parse : char Stream.t -> result

val isReturn : result -> bool

val findNode : Types.Function.extension * Types.Statement.extension -> FlowGraph.node

val addNodes : Types.Statement.key -> result -> unit
val addEdges : Symtab.t -> Types.Statement.key -> result -> unit
