class type constantComparisonAccumulator =
  object
    method addInspirationInfo : (int * Cil.exp) list -> unit
    method getInfos : unit -> (int * Cil.exp) list list
  end

val getAccumulator : constantComparisonAccumulator

val printAll : Digest.t Lazy.t -> out_channel -> (int * Cil.exp) list list -> unit
