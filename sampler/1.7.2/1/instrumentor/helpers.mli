open Cil
(* cci helper functions*)
 
(*returns true if the lval is a bitfield*)
val is_bitfield :lval -> bool

(* gets filename before . *)
val scrub_filename : string -> string

(*generates prefix from file *)
val get_prefix_file: file -> string

(*return the local var with given name*)
(*create one if it doesn't exist*)
(*by default, an integer variable is created*)
val findOrCreate_local:  fundec -> string -> varinfo 

(*return the local var with given name*)
(*create one if it doesn't exist*)
val findOrCreate_local_type:  fundec -> string -> typ -> varinfo 

(*return the global var with given name*)
(*create one if it doesn't exist*)
(*by default, an integer variable is created*)
val findOrCreate_global: file -> string -> varinfo
