open Cil
open DescribedExpression
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file

    val bumper = BumpSign.bump file

    method bump func location result =
      let siteId = self#addSiteInfo { location = location; fundec = func;
				      description = result.doc }
      in
      bumper siteId location result.exp zero
  end
