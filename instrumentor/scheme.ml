open Cil


class virtual c file =
  object (self)
    method virtual private findSites : fundec -> unit
    method virtual embedInfo : Digest.t Lazy.t -> unit

    method findAllSites =
      let findFuncs = function
	| GFun (fundec, _) -> self#findSites fundec
	| _ -> ()
      in
      iterGlobals file findFuncs
  end
