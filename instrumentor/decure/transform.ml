open Cil
open Str


let checkPattern = regexp "^__CHECK_"


class visitor = object
  inherit FunctionBodyVisitor.visitor
      
  method vinst inst =
    begin
      match inst with
      | Call (_, Lval (Var varinfo, NoOffset), _, location)
	when string_match checkPattern varinfo.vname 0 ->
	  ignore (Pretty.eprintf "%a: %s\n"
		    d_loc location varinfo.vname)
      | _ -> ()
    end;
    SkipChildren
  end


let phase =
  "Transform",
  visitCilFile (new visitor)
