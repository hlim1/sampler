open Cil


type slice = lval


class virtual builder : file ->
  object
    method private addSiteInfo : SiteInfo.t -> slice
    method finalize : unit
  end
