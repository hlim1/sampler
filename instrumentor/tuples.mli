open Cil


type siteId = int


class virtual builder : string -> file ->
  object
    method private addSiteInfo : SiteInfo.t -> siteId
    method finalize : Digest.t Lazy.t -> unit
  end
