open Cil
(* cci helper functions*)

(*returns true if the lval is a bitfield*)
val is_bitfield :lval -> bool

(*returns true if the lval has register storage*)
val is_register :lval -> bool


(* gets filename before . *)
val scrub_filename : string -> string


(*generates prefix from file *)
val get_prefix_file: file -> string


(*generates prefix from func and file *)
val get_prefix: fundec -> file -> string

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

(* return true if the lval is a global*)
val isInterestingLval : file -> lval -> bool 

(*return true if the expr contains a global*)
val isInterestingExp : file -> exp -> bool 
      
(* return true if the lval is a global*)
val isGlobalLval:  file -> lval -> bool 

(*return true if the expr contains a global*)
val hasGlobal: file -> exp -> bool 
