class type constantComparisonAccumulator =
 object
   method addInspirationInfo : (int * int64) list -> unit 
   method getInfos : unit -> (int * int64) list list
 end

val getAccumulator : constantComparisonAccumulator 

val printAll : Digest.t Lazy.t -> out_channel -> (int * int64) list list -> unit
