open Cil


class manager : SchemeName.t -> file ->
  object
    method addSite : fundec -> exp -> Pretty.doc -> location -> stmt
    method patch : unit
    method saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end
