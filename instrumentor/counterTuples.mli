open Cil


class type manager =
  object
    method addSite : fundec -> exp -> Pretty.doc -> location -> stmt
    method finalize : Digest.t Lazy.t -> unit
  end


val build : SchemeName.t -> file -> manager
