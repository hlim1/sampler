open Types


val p : char Stream.t -> node * int list


val fixParent : func -> node -> unit
val fixSuccessors : node array -> (node * int list) -> unit
val fixCallees : environment -> node -> unit

val isReturn : node -> bool

val addCallSuccessors : node -> unit
