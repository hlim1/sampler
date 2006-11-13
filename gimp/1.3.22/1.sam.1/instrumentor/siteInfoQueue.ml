open Cil
open Pretty
open SiteInfo


class container =
  object (self)
    inherit [SiteInfo.t] QueueClass.container

    method serialize signature =
      let folder prefix site =
	let location = get_stmtLoc site.statement.skind in
	let file = if location.file = "" then "(unknown)" else location.file in
	let line = if location.line = -1 then 0 else location.line in
	prefix
	  ++ seq (chr '\t') (fun d -> d) [text file;
					  num line;
					  text site.fundec.svar.vname;
					  num site.statement.sid;
					  site.description]
	  ++ Pretty.line
      in
      let doc = self#fold folder (text (Digest.to_hex signature) ++ chr '\n') ++ line in
      sprint max_int doc
  end
