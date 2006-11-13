open Cil


type siteId = int


class virtual builder : file ->
  object
    method private addSiteInfo : SiteInfo.t -> siteId
    method finalize : unit
  end
