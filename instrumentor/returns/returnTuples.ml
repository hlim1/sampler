open Cil
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file


    method bump func location exp desc =
      let slice = self#addSiteInfo { location = location; fundec = func;
				     description = desc }
      in
      Bump.bump location exp slice
  end
