open Cil


type strongest = Declared of varinfo | Defined of fundec


class visitor index =
  object
    inherit SkipVisitor.visitor

    method vglob global =
      begin
	match global with
	| GVarDecl ({vtype = TFun _} as varinfo, _) ->
	    if not (index#mem varinfo) then
	      index#add varinfo (Declared varinfo)

	| GFun (fundec, _) ->
	    index#replace fundec.svar (Defined fundec)

	| _ ->
	    ()
      end;
      SkipChildren
  end


let build file =
  let map = new VariableNameMap.container in
  let visitor = new visitor map in
  visitCilFileSameGlobals visitor file;
  map
