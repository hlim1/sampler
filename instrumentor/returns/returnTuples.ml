open Cil
open DescribedExpression
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file

    val bumper = Bump.bump file

    method bump func location result =
      let slice = self#addSiteInfo { location = location; fundec = func;
				     description = result.doc }
      in
      bumper location result.exp slice
  end
