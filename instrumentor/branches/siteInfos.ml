open Cil
open Pretty
open SiteInfo


let serialize (sites : SiteInfoQueue.container) signature =
  let folder prefix site =
    prefix
      ++ seq (chr '\t') (fun d -> d) [text site.location.file;
				      num site.location.line;
				      num site.location.byte;
				      d_exp () site.condition]
      ++ line
  in
  let doc = sites#fold folder (text (Digest.to_hex signature) ++ chr '\n') ++ line in
  sites#clear;
  sprint max_int doc
