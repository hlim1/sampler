open Cil
open SchemeName


class virtual c name (file : file) =
  object (self)
    method findAllSites =
      TestHarness.time ("  finding " ^ name.flag ^ " sites")
	(fun () -> Scanners.iterFuncs file self#findSites)

    method virtual embedInfo : Digest.t Lazy.t -> unit
  end
