open Cil
open DescribedExpression
open Pretty
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file

    val bumper = BumpSign.bump file

    method bump func location left right =
      let siteId = self#addSiteInfo { location = location; fundec = func;
				      description = left.doc ++ chr '\t' ++ right.doc }
      in
      bumper siteId location left.exp right.exp
  end
