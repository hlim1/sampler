open Cil
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file


    method bump func location expression =
      let local = var (makeTempVar func (typeOf expression)) in

      let bump =
	let slice = self#addSiteInfo { location = location; fundec = func;
				       description = d_exp () expression }
	in
	Bump.bump location (Lval local) slice
      in

      local, bump
  end
