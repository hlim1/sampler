open Cil
open DescribedExpression
open Pretty
open SiteInfo


class builder file =
  object (self)
    inherit Tuples.builder file

    val bumper = BumpSign.bump file

    method bump func location left right =
      let slice = self#addSiteInfo { location = location; fundec = func;
				     description = left.doc ++ chr '\t' ++ right.doc }
      in
      bumper location left.exp right.exp slice
  end
