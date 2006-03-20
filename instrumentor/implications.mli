type t

class type constantComparisonAccumulator =
 object
   method addInspirationInfo : (int * int64) list -> unit 
   method getInfos : unit -> (int * int64) list list
 end

val getAccumulator : constantComparisonAccumulator 

val analyzeAll : (int * int64) list list -> t 

val printAll : Digest.t Lazy.t -> out_channel -> t -> unit
