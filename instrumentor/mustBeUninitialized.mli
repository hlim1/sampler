open Cil

(* Takes a function and a list of variables of interest. Returns a filter
that takes a statement and returns a function that takes a variable and:
- throws an exception if the variable was not one of the original variables of 
  interest
- returns false if the analysis found that the statement was unreachable
- returns false if the analysis found that the variable must still be
  uninitialized when that statement is reached 
- returns true if the analysis found that the variable might have been 
  initialized when that statement is reached 
*)
val computeUninitialized : fundec -> varinfo list -> stmt -> varinfo -> bool 
