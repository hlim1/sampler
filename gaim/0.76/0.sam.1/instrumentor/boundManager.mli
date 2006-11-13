open Cil


val register : (varinfo * varinfo) -> (fundec * location * Pretty.doc * stmt) -> unit
val patch : file -> unit
val saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
