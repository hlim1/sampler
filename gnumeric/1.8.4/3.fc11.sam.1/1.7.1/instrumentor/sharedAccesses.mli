open Cil


(** if enabled, rewrite all function bodies so that each Set
   instruction accesses at most one shared, mutable location, and no
   other statements access any shared, mutable locations at all *)
val isolate : file -> unit

(** return the single shared, mutable location accessed by this
   instruction, if any *)
val isolated : instr -> lval option
