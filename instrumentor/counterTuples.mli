open Cil


class type manager =
  object
    method addSite : fundec -> exp -> Pretty.doc -> location -> stmt
    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end


val build : SchemeName.t -> file -> manager
