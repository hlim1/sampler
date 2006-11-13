open Cil
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file

    val bumper = Bump.bump file

    method bump func location statement expression =
      let local = var (makeTempVar func (typeOf expression)) in

      let bump =
	let siteId = self#addSiteInfo { fundec = func;
					statement = statement;
					description = d_exp () expression }
	in
	bumper siteId location (Lval local)
      in

      local, bump
  end
