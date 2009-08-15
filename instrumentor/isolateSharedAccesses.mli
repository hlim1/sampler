(** rewrite all function bodies so that no single statement
    accesses more than one shared, mutable location *)
val visit : Cil.file -> unit
