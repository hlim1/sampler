open Cil
open SchemeName


class virtual c name (file : file) =
  object (self)
    method findAllSites =
      TestHarness.time ("  finding " ^ name.flag ^ " sites")
	(fun () -> Scanners.iterFuncs file self#findSites)

    method virtual saveSiteInfo : Digest.t Lazy.t -> out_channel -> unit
  end
