open Cil
open Pretty
open SiteInfo


class container =
  object (self)
    inherit [SiteInfo.t] QueueClass.container

    method serialize signature =
      let folder prefix site =
	prefix
	  ++ seq (chr '\t') (fun d -> d) [text site.location.file;
					  num site.location.line;
					  num site.location.byte;
					  site.description]
	  ++ line
      in
      let doc = self#fold folder (text (Digest.to_hex signature) ++ chr '\n') ++ line in
      sprint max_int doc
  end
